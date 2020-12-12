import os
import sqlite3

import pandas as pd

sqlite_connection = sqlite3.connect('data.db')
cursor = sqlite_connection.cursor()


def get_rows_by_year(year=2010):
    sas_filenames = {
        r'data_sas\Kidney_ Pancreas_ Kidney-Pancreas\kidpan_data.sas7bdat': "TX_DATE",
        # r'data_sas/Kidney_ Pancreas_ Kidney-Pancreas/HLA Additional/kidpan_addtl_hla.sas7bdat', # No Date
        # r'data_sas/Kidney_ Pancreas_ Kidney-Pancreas/PRA and Crossmatch/kidpan_pra_crossmatch_data.sas7bdat',
        # r'data_sas/Kidney_ Pancreas_ Kidney-Pancreas/Waiting List History/kidpan_wlhistory_data.sas7bdat',
        r'data_sas/Living Donor/living_donor_data.sas7bdat': "DON_DATE",
        r'data_sas/Deceased Donor/deceased_donor_data.sas7bdat': "DON_DATE",
        # r'data_sas/Kidney_ Pancreas_ Kidney-Pancreas/Post-Transplant Malignancy/kidney_malig_followup_data.sas7bdat',
        # r'data_sas/Kidney_ Pancreas_ Kidney-Pancreas/Immunosuppression/kidpan_immuno_discharge_data.sas7bdat',
        # r'data_sas/Kidney_ Pancreas_ Kidney-Pancreas/Immunosuppression/kidpan_immuno_followup_data.sas7bdat'
        # r'data_sas/Kidney_ Pancreas_ Kidney-Pancreas/Individual Follow-up Records/kidney_followup_data.sas7bdat',
        # r'data_sas/Kidney_ Pancreas_ Kidney-Pancreas/Individual Follow-up Records/kidpan_followup_data.sas7bdat'
    }

    for filename, column_name in sas_filenames.items():
        # Gets only the table name, i.e. the filename without SAS extension
        table_name = os.path.basename(filename).replace(".sas7bdat", "")
        query = f"SELECT * FROM (SELECT *, strftime('%Y', {column_name}) as Year FROM {table_name}) data WHERE Year = '2010'"

        df = pd.read_sql_query(query, sqlite_connection)

        new_filename = filename.replace("data_sas", "out").replace("sas7bdat","csv")
        os.makedirs(os.path.dirname(new_filename), exist_ok=True)
        df.to_csv(new_filename, header=True)

        exit()


if __name__ == "__main__":
    get_rows_by_year()
