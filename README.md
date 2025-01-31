# metview

The European Centre for Medium-Range Weather Forecast ([ECMWF](https://www.ecmwf.int)) provides the metview software
package which can be used to inspect, analyse, process and visualze meteorological data. ECMWF also provides a Python
interface for it. We have created a simple Docker image to make use of
the [metview bundle](https://confluence.ecmwf.int/display/METV/The+Metview+Source+Bundle) and prepare the Python
bindings. This Dockerfile compiles the metview package for non-interactive use.

## Usage

See [ghcr.io/dzfranklin/metview:latest](https://github.com/dzfranklin/metview-docker/pkgs/container/metview)

## Credit

Based on [github.com/meteoiq/metview](https://github.com/meteoiq/metview)
