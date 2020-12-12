import os

import pandas as pd
from pandas.io.sas.sasreader import ReaderBase
from sqlalchemy import create_engine
from sqlalchemy.engine.reflection import Inspector

engine = create_engine("sqlite:///data.db", echo=False)
sqlite_connection = engine.connect()


def generate_sql_tables(overwrite=False):
    inspector = Inspector.from_engine(engine)
    tables_already_created = inspector.get_table_names()

    sas_filenames = [
        r'data_sas\Kidney_ Pancreas_ Kidney-Pancreas\kidpan_data.sas7bdat',
        r'data_sas/Kidney_ Pancreas_ Kidney-Pancreas/HLA Additional/kidpan_addtl_hla.sas7bdat',
        r'data_sas/Kidney_ Pancreas_ Kidney-Pancreas/PRA and Crossmatch/kidpan_pra_crossmatch_data.sas7bdat',
        r'data_sas/Kidney_ Pancreas_ Kidney-Pancreas/Waiting List History/kidpan_wlhistory_data.sas7bdat',
        r'data_sas/Living Donor/living_donor_data.sas7bdat',
        r'data_sas/Deceased Donor/deceased_donor_data.sas7bdat',
        r'data_sas/Kidney_ Pancreas_ Kidney-Pancreas/Post-Transplant Malignancy/kidney_malig_followup_data.sas7bdat',
        r'data_sas/Kidney_ Pancreas_ Kidney-Pancreas/Immunosuppression/kidpan_immuno_discharge_data.sas7bdat',
        r'data_sas/Kidney_ Pancreas_ Kidney-Pancreas/Immunosuppression/kidpan_immuno_followup_data.sas7bdat',
        r'data_sas/Kidney_ Pancreas_ Kidney-Pancreas/Individual Follow-up Records/kidney_followup_data.sas7bdat',
        r'data_sas/Kidney_ Pancreas_ Kidney-Pancreas/Individual Follow-up Records/kidpan_followup_data.sas7bdat'
    ]

    for filename in sas_filenames:
        # Gets only the table name, i.e. the filename without SAS extension
        table_name = os.path.basename(filename).replace(".sas7bdat", "")

        # Check if table name already exists and we don't want to overwrite
        if table_name in tables_already_created and not overwrite:
            continue

        # Read data in chunks of 10,000
        # reader = pd.read_sas(filename, chunksize=10_000, encoding="utf-")
        reader = pd.read_sas(filename, chunksize=10_000)
        chunk_no = 0

        # noinspection PyTypeChecker
        for chunk in reader:
            # Adds number of rows in current chunk to the total count
            chunk_no += chunk.shape[0]
            for col in chunk:
                if chunk[col].dtype == "object":
                    chunk[col] = chunk[col].str.decode("utf-8", errors="replace")
            chunk.to_sql(table_name, sqlite_connection, if_exists='append')
            print(f"Wrote {chunk_no} entries for {table_name}")

        print(f"Successfully wrote {chunk_no} entries for {table_name}")


if __name__ == "__main__":
    generate_sql_tables()
