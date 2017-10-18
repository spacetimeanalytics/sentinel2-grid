#!/bin/bash
#
#  Download Sentinel-2 tilling grid (KML) and convert do SHP.
#

set -e -x

sentinel2_grid_url=https://sentinel.esa.int/documents/247904/1955685/S2A_OPER_GIP_TILPAR_MPC__20151209T095117_V20150622T000000_21000101T000000_B00.kml
tempdir=$(mktemp -d)

download_url() {
    curl -o $2 $1
    if [[ "$?" -ne "0" ]]; then
        wget -O $2 $1
    fi
    return 0
}


download_url $sentinel2_grid_url $tempdir/sentinel2_grid.kml

ogr2ogr -nlt Polygon \
        -select name \
        -skipfailures \
        -f 'ESRI Shapefile' \
        $tempdir/sentinel2_grid.shp \
        $tempdir/sentinel2_grid.kml

tar -czv -C $tempdir -f sentinel2_grid.tar.gz sentinel2_grid.{dbf,prj,shp,shx}

rm $tempdir -r
