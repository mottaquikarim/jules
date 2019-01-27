from setuptools import find_packages, setup

setup(
    name='jules',
    version='0.0.1',
    description='Project Management App',
    package_dir={'': 'src'},
    packages=find_packages(where='src'),
    zip_safe=True,
    setup_requires=['wheel'],
)
