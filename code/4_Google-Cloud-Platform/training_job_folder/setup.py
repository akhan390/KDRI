from setuptools import find_packages
from setuptools import setup

REQUIRED_PACKAGES = ['scikit-survival>=0.14', 'gcsfs>=0.7.1']

setup(
    name='trainer',
    version='1.0',
    install_requires=REQUIRED_PACKAGES,
    packages=find_packages(),
    include_package_data=True,
    description='Scikit-Survival'
)