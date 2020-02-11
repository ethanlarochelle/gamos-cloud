# GAMOS 6.1 in the cloud
The notebooks in this module demonstrate how GAMOS 6.1 with the Dartmouth tissue optics plugin can be configured using a Docker container and deployed in the cloud. This code is a supplement of the corresponding publication in TBD, titled: *A parallel container-based implementation of GAMOS for Monte Carlo modeling radiation-induced light transport using on-demand cloud infrastructure*

The code is organized into four Python Notebooks.

## gamos-structure-viz.ipynb
This notebook provides a graphical representation of the GAMOS code structure.

## gamos-geom-mpt-helper.ipynb
Defining wavelength-dependent optical properties to materials in GAMOS can be a time-consuming and error-prone process. This notebook tries to address this for simple multi-layer geometries by reading the definitions from an Excel spreadsheet and converting it to a GAMOS-compatible world.geom text file.

## gamos-cloud-config.ipynb
The bulk of the code is provided in this notebook. Using the AWS Python SDK (Boto3), this notebook demonstrates how to create the initial GAMOS container, and then goes further into how to define AWS Batch jobs which can be used to run multiple simulations in parallel.

## gamos-sim-analysis.ipynb
Examples of how to re-combine the simulation output files is provided in this notebook.
