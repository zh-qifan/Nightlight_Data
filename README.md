# Nightlight Data 
## Background
Nightlight data (or nighttime satellite imagery data) is widely used as an alternative dataset to approximate economics activity of regions because the data is available over time and for almost all the inhabited surface of the earth. For example, [Henderson et al. (2012)](https://edisciplinas.usp.br/pluginfile.php/4253686/mod_resource/content/1/Henderson%20et%20al%20-%20Measuring%20Economic%20Growth%20from%20Outer%20Space%20-%20AER%202012.pdf) develops a statistical framework to use satellite data on nightlights to augment official income growth measures. [Martínez (2022)](https://www.journals.uchicago.edu/doi/full/10.1086/720458#:~:text=This%20autocracy%20gradient%20in%20the,GDP%20growth%20by%20approximately%2035%25.) studies the overstatement of economic growth in autocracies by comparing self-reported GDP figures to night-time light recorded by satellites from outer space. [Vogel et al. (2024)](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=4707908) integrates daytime and nighttime satellite imagery into a spatial general-equilibrium model to evaluate the returns to investments in new motorways in India.

In this project, I provided an overview of nightlight data source and processed the nightlight data in Mexico. In addition, I also collected Mexico census data to explore their correlation with nightlight intensity.

## Introduction on Major Data Sources
The main data sources that most nightlight-related literature depends on is DMSP-OLS (1992 - 2013) + VIIRS-DNB (2012 - Present). The following table  is a comparison between the two data sources. The two data sources can provide global daytime and nighttime light data of the Earth every 24 hours, but only a portion of them is of high quality.  

    
|  | DMSP-OLS | VIIRS-DNB |
| --- | --- | --- |
| Time Range | 1992-01-01 - 2014-01-01 | 2012-02-07 - Present |
| Temporal Resolution | Daily | Daily |
| Spatial Coverage | Global | Global |
| Spatial Resolution | 5km x 5km | 742m x 742m |
| Spectral Resolution | Single panchromatic channels covering the wavelengths ranging from 500 to 900 nanometers. | Single panchromatic channels covering the wavelengths ranging from 500 to 900 nanometers. |
| Quantization (Largest light intensity) | 6 bit | 14 bit |
| Raw Data Availability | Yes. One requires a fee ([NOAA](https://ngdc.noaa.gov/eog/availability.html)) and one is free ([Open Nighttime Lights](https://worldbank.github.io/OpenNightLights/wb-light-every-night-readme.html#viirs-dnb)). | Yes and open-source. There are two sources: [NASA](https://ladsweb.modaps.eosdis.nasa.gov/search/order/1/VNP46A1--5000,VNP46A2--5000,VNP46A4--5000,VNP46A3--5000/2024-02-07..2024-02-08/NB/Country:USA,MEX) and [NOAA](https://ncc.nesdis.noaa.gov/VIIRS/).  |

There are also some preprocessed composite products with lower temporal resolution but easier to use.

| Product | Base Data | Temporal Resolution | Spatial Resolution | Spatial Coverage |
| --- | --- | --- | --- | --- |
| [DMSP OLS: Nighttime Lights Time Series Version 4](https://developers.google.com/earth-engine/datasets/catalog/NOAA_DMSP-OLS_NIGHTTIME_LIGHTS) | DMSP-OLS | Annual (1992 - 2013) | 30 arc second (~1km at the Equator) | 180W, 75N, 65S, 180E (Thus the US, Mexico and Costa Rico should be recorded.) |
| [Annual VNL V2](https://eogdata.mines.edu/products/vnl/#monthly) | VIIRS-DNB | Annual (2012 - 2022) | 15 arc second (~500m at the Equator) | 180W, 75N, 65S, 180E (Thus the US, Mexico and Costa Rico should be recorded.) |
| [Light Every Night](https://worldbank.github.io/OpenNightLights/wb-light-every-night-readme.html) | DMSP-OLS + VIIRS-DNB | DMSP-OLS: Daily (1992-2017); IRS-DNB: Daily (~6 minute orbital segments from 2012 - 2020) | Same as the raw data. | Global |

Here are some wonderful nighttime light interactive maps.

1.  [https://eogdata.mines.edu/products/trip_the_light/](https://eogdata.mines.edu/products/trip_the_light/) This one has good resolution but it does not provide option to change the date.
2. [https://ladsweb.modaps.eosdis.nasa.gov/view-data/#l:VIIRS_SNPP_DayNightBand_At_Sensor_Radiance;@94.5,7.9,2.6z](https://ladsweb.modaps.eosdis.nasa.gov/view-data/#l:VIIRS_SNPP_DayNightBand_At_Sensor_Radiance;@94.5,7.9,2.6z)

## Extract Nightlight Data in Mexico