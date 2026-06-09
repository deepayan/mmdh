# mmdh

Helper Functions for MoSPI Microdata

This package is currently in development, and can only be obtained
from GitHub. To install, run

```r
remotes::install_github("deepayan/mmdh")
```

The `remotes` package neeeds to be installed first (it is available on
CRAN).

## Background

The Ministry of Statistics and Programme Implementation (MoSPI), Govt
of India, makes anonymized unit-level data (aka microdata) from many
of its surveys [available online](https://microdata.gov.in/).
Registration is required for access to the data, which may not be
shared with any other individual or organization without prior
approval from MoSPI. See
[here](https://microdata.gov.in/NADA/index.php/dissemination) for
details.

The goal of this package is to provide helper functions to preprocess
the data to make it ready for further analysis in R _after_ it has
been downloaded. Unfortunately, the details of what is available,
including the data format, vary substantially from one survey to
another, so this process will need to be tailored accordingly.

## API usage

The files available on the MoSPI [microdata
portal](https://microdata.gov.in/) can be downloaded manually, but can
also be downloaded through a web API [described
here](https://microdata.gov.in/NADA/api-documentation/catalog/). In
either case, you will need to register first. To use the API, you will
need to generate an API key by going to your "Profile" page once you
are logged into the MoSPI microdata portal. 

The following functions in this package wrap the relevant API calls
inside R functions to provide a convenient way to download these files
from R. Note that this is simply an alternative to downloading the
files directly from the website, and does not provide access to any
additional material.


### Setup

```r
library(mmdh)
Sys.setenv(MOSPI_API_KEY = "your-api-key")
```

### List available datasets

```r
dlist <- list_datasets()
dlist
```

|id  |type   |idno                                                      |title                                                                                                                                                     |repositoryid |repo_title                         |
|:---|:------|:---------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------|:------------|:----------------------------------|
|293 |survey |DDI-IND-NSO-ASUSE-Jan2025-Dec2025                         |Annual Survey of Unincorporated Sector Enterprises (ASUSE) : 2025 (January 2025 – December 2025)                                                          |ENT          |Enterprises Surveys                |
|292 |survey |DDI-IND-NSO-PLFS-Apr-Jun2025-to-Oct-Dec2025               |unit-level data of PLFS for quarterly (Apr-June 2025 to Oct-Dec 2025)                                                                                     |PLFS         |Periodic Labour Force Survey       |
|291 |survey |DDI-IND-NSO-PLFS-Apr2025-Dec2025                          |unit-level data of PLFS for monthly (April to December 2025)                                                                                              |PLFS         |Periodic Labour Force Survey       |
|290 |survey |DDI-IND-NSO-HSCHealth80R-Jan2025-Dec2025                  |Survey on Household Social Consumption:Health(Jan-Dec25)                                                                                                  |CEXP         |Household Consumption Expenditure  |
|284 |survey |DDI-IND-NSO-PLFS-Jan2025-Dec2025                          |Periodic Labour Force Survey (PLFS),Calendar Year 2025 (Jan-Dec25)                                                                                        |PLFS         |Periodic Labour Force Survey       |
|277 |survey |DDI-IND-NSO-ASI-2019-20                                   |Annual Survey of Industries 2019-20                                                                                                                       |ASI          |Annual Survey of Industries        |
|275 |survey |DDI-IND-NSO-ASI-2020-21                                   |Annual Survey of Industries 2020-21                                                                                                                       |ASI          |Annual Survey of Industries        |
|256 |survey |DDI-IND-NSO-ASI-2023-24                                   |Annual Survey of Industries 2023-24                                                                                                                       |ASI          |Annual Survey of Industries        |
|255 |survey |DDI-IND-MOSPI-NSS-CMSE80-2025                             |Comprehensive Modular Survey on Education-NSS 80th Round-2025                                                                                             |OTH          |Other Surveys                      |
|254 |survey |DDI-IND-NSO-PLFS-2024-24                                  |Periodic Labour Force Survey (PLFS), Key Employment Unemployment Indicators for (January 2024 - December 2024)                                            |PLFS         |Periodic Labour Force Survey       |
|239 |survey |DDI-IND-MOSPI-NSS-CMST80-2025                             |Comprehensive Modular Survey on Telecom-NSS 80th Round-2025                                                                                               |OTH          |Other Surveys                      |
|238 |survey |DDI-IND-MOSPI-NSS-ASUSE23-24                              |Annual Survey of Unincorporated Sector Enterprises (ASUSE) of 2023-2024                                                                                   |ENT          |Enterprises Surveys                |
|237 |survey |DDI-IND-MOSPI-NSS-HCES23-24                               |Household Consumption Expenditure Survey: 2023-24                                                                                                         |CEXP         |Household Consumption Expenditure  |
|236 |survey |DDI-IND-NSO-TUS-2024-24                                   |Time Use Survey (TUS), January 2024-December 2024                                                                                                         |OTH          |Other Surveys                      |
|230 |survey |DDI-IND-NSO-UFS                                           |Urban Frame Survey (UFS) Summary Data                                                                                                                     |OTH          |Other Surveys                      |
|224 |survey |DDI-IND-MOSPI-NSSO-HCES22-23                              |Household Consumption Expenditure Survey: 2022-23                                                                                                         |CEXP         |Household Consumption Expenditure  |
|223 |survey |DDI-IND-CSO-TUS-2019-19                                   |Time Use Survey (TUS), January 2019-December 2019                                                                                                         |OTH          |Other Surveys                      |
|222 |survey |DDI-IND-MOSPI-NSSO-ASUSE2223                              |Annual Survey of Unincorporated Sector Enterprises (ASUSE) of 2022-2023                                                                                   |ENT          |Enterprises Surveys                |
|221 |survey |DDI-IND-MOSPI-NSSO-ASUSE2122                              |Annual Survey of Unincorporated Sector Enterprises (ASUSE) of 2021-2022                                                                                   |ENT          |Enterprises Surveys                |
|220 |survey |DDI-IND-MOSPI-NSSO-CAMS22-23                              |Comprehensive Annual Modular Survey (CAMS),NSS 79th round: 2022-23                                                                                        |OTH          |Other Surveys                      |
|218 |survey |DDI-IND-CSO-MIS-78-2020                                   |Multiple Indicator Survey(MIS), NSS 78th Round                                                                                                            |OTH          |Other Surveys                      |
|217 |survey |DDI-IND-CSO-PLFS-2019-20                                  |Periodic Labour Force Survey (PLFS), July 2019-June 2020                                                                                                  |PLFS         |Periodic Labour Force Survey       |
|216 |survey |DDI-IND-CSO-PLFS-2018-19                                  |Periodic Labour Force Survey (PLFS), July 2018-June 2019                                                                                                  |PLFS         |Periodic Labour Force Survey       |
|214 |survey |DDI-IND-CSO-PLFS-2021-22                                  |Periodic Labour Force Survey (PLFS), July 2021-June 2022                                                                                                  |PLFS         |Periodic Labour Force Survey       |
|213 |survey |DDI-IND-CSO-PLFS-2023-24                                  |Periodic Labour Force Survey (PLFS), July 2023-June 2024                                                                                                  |PLFS         |Periodic Labour Force Survey       |
|211 |survey |DDI-IND-CSO-PLFS-2022-22                                  |Periodic Labour Force Survey (PLFS), Calendar Year 2022 (Jan22 Dec22)                                                                                     |PLFS         |Periodic Labour Force Survey       |
|210 |survey |DDI-IND-CSO-PLFS-2022-23                                  |Periodic Labour Force Survey (PLFS), July, 2022- June,2023                                                                                                |PLFS         |Periodic Labour Force Survey       |
|209 |survey |DDI-IND-CSO-PLFS-2021-21                                  |Periodic Labour Force Survey (PLFS), Calendar Year 2021 (Jan21 Dec21)                                                                                     |PLFS         |Periodic Labour Force Survey       |
|208 |survey |DDI-IND-CSO-PLFS-2023-23                                  |Periodic Labour Force Survey (PLFS), Calendar Year 2023 (Jan23 Dec23)                                                                                     |PLFS         |Periodic Labour Force Survey       |
|206 |survey |DDI-IND-CSO-PLFS-2020-21                                  |Unit Level Data of Periodic Labour Force Survey (PLFS) July 2020-June 2021                                                                                |PLFS         |Periodic Labour Force Survey       |
|205 |survey |DDI-IND-NSO-ASI-2022-23                                   |Annual Survey of Industries 2022-23                                                                                                                       |ASI          |Annual Survey of Industries        |
|188 |survey |DDI-IND-NSO-ASI-2021-22                                   |Annual Survey of Industries 2021-22                                                                                                                       |ASI          |Annual Survey of Industries        |
|157 |survey |DDI-IND-MOSPI-NSSO-77Rnd-Sch33.1-January2019-December2019 |Land and Livestock Holding of Households and Situation Assessment of Agricultural Households)-JANUARY 2019 – DECEMBER 2019-Visit 1 and Visit 2 77th Round |central      |                                   |
|156 |survey |DDI-IND-MOSPI-NSSO-77Rnd-Sch18.2-January2019-December2019 |Debt and Investment 77th Round:JANUARY 2019 – DECEMBER 2019-Visit 1 and Visit 2                                                                           |central      |                                   |
|154 |survey |DDI-IND-MOSPI-NSSO-76Rnd-Sch26.0-July2018-December2018    |Survey of Persons with Disabilities NSS 76th Round : July 2018 - December 2018                                                                            |central      |                                   |
|153 |survey |DDI-IND-MOSPI-NSSO-76Rnd-Sch1.2-July2018-December2018     |Drinking Water, Sanitation, Hygiene and Housing Condition NSS 76th Round : July 2018- December  2018                                                      |central      |                                   |
|152 |survey |DDI-IND-MOSPI-NSSO-75Rnd-Sch25.0-July2017-June2018        |Household Social Consumption: Health, NSS 75th Round Schedule-25.0 :July 2017-June 2018                                                                   |central      |                                   |
|151 |survey |DDI-IND-MOSPI-NSSO-75Rnd-Sch25.2-July2017-June2018        |Household Social Consumption: Education, NSS 75th Round Schedule-25.2 :July 2017-June 2018                                                                |central      |                                   |
|150 |survey |DDI-IND-NSO-ASI-2018-19                                   |Annual Survey of Industries 2018-19                                                                                                                       |ASI          |Annual Survey of Industries        |
|149 |survey |IND-CSO-ASI-2017-18                                       |Annual Survey of Industries 2017-18                                                                                                                       |ASI          |Annual Survey of Industries        |
|148 |survey |DDI-IND-CSO-IIP                                           |Index of Industrial Production (IIP) with Base year 2011-12                                                                                               |central      |                                   |
|145 |survey |IND-CSO-ASI-2016-17                                       |Annual Survey of Industries 2016-17                                                                                                                       |ASI          |Annual Survey of Industries        |
|143 |survey |IND-CSO-ASI-2015-16                                       |Annual Survey of Industries 2015-16                                                                                                                       |ASI          |Annual Survey of Industries        |
|142 |survey |IDDI-IND-MOSPI-3-EC-1990                                  |Third  Economic Census 1990                                                                                                                               |central      |                                   |
|141 |survey |DDI-IND-MOSPI-NSSO-70th-Sch18dot1-visit1-2013             |Land and Livestock Holdings Survey Visit 1,  January -July 2013                                                                                           |LLS          |Land and Livestock Holding Surveys |
|140 |survey |IND-CSO-TUS-1998-v1.0                                     |Time Use Survey 1998                                                                                                                                      |OTH          |Other Surveys                      |
|139 |survey |DDI-IND-MOSPI-NSSO-73Rnd-Sch2.34-July2015-June2016        |Unincorporated Non-Agricultural Enterprises (Excluding Construction) - JULY 2015 - JUNE 2016                                                              |ENT          |Enterprises Surveys                |
|138 |survey |DDI-IND-MOSPI-NSSO-72Rnd-Sch21.1-July2014-June2015        |Domestic Tourism Expenditure  - JULY 2014 - JUNE 2015                                                                                                     |OTH          |Other Surveys                      |
|137 |survey |DDI-IND-MOSPI-NSSO-72Rnd-Sch1.5-July2014-June2015         |Household  expenditure on  Services  and  Durable  goods - JULY 2014 - JUNE 2015                                                                          |CEXP         |Household Consumption Expenditure  |
|136 |survey |IND-NSSO-SCES-2014-v1.0                                   |Social Consumption - Education Survey 2014                                                                                                                |OTH          |Other Surveys                      |
|134 |survey |DDI-IND-MOSPI-NSSO-70Rnd-Sch33-visit2-Jan-Dec2013         |Situation Assessment survey of Agricultural households,  NSS 70th Round : Jan - Dec 2013 : Visit 2                                                        |central      |                                   |
|133 |survey |IND-NSSO-SAS-2013-v1.0                                    |Situation Assessment Survey of Agricultural Households, January - December 2013                                                                           |central      |                                   |
|132 |survey |DDI-IND-MOSPI-NSSO-70Rnd-Sch18pt2-Jan-Dec2013V2           |Debt & Investment Visit 2 , Jan - Dec 2013                                                                                                                |central      |                                   |
|131 |survey |DDI-IND-MOSPI-NSSO-70th-Sch18dot1-visit2-2013             |Land and Livestock Holdings Survey Visit 2 , August - December 2013                                                                                       |LLS          |Land and Livestock Holding Surveys |
|130 |survey |DDI-IND-MOSPI-NSSO-70Rnd-Sch18pt2-Jan-Dec20131            |Debt & Investment, NSS 70th Round Visit-1: Jan - Dec 2013                                                                                                 |OTH          |Other Surveys                      |
|129 |survey |DDI-IND-MOSPI-NSSO-69Rnd-Sch1dot2-2012                    |Drinking water, sanitation, hygiene and housing condition : NSS 69th Round : July 2012- Dec  2012                                                         |central      |                                   |
|128 |survey |DDI-IND-MOSPI-NSSO-69Rnd-Sch-0dot21-2012                  |Urban Slums Survey, July 2012 - December 2012                                                                                                             |OTH          |Other Surveys                      |
|127 |survey |DDI-IND-MOSPI-NSSO-68-10-2013                             |Employment and Unemployment, July 2011- June 2012                                                                                                         |central      |                                   |
|126 |survey |DDI-IND-MOSPI-NSSO-68Rnd-Sch2.0-July2011-June2012         |Household Consumer Expenditure, NSS 68th Round Sch1.0 Type 2 : July 2011 - June 2012                                                                      |central      |                                   |
|125 |survey |IND-NSSO-SUNAE-2010-v1.0                                  |Survey on Unincorporated Non-Agricultural Enterprises (Excluding Construction) July-June 2010-11                                                          |ENT          |Enterprises Surveys                |
|124 |survey |DDI-IND-MOSPI-NSSO-66-10-2011                             |Employment and Unemployment, July  2009 - June 2010                                                                                                       |central      |                                   |
|123 |survey |DDI-IND-NSSO-66-SCHEDULE-1.0T2                            |Household Consumer Expenditure, July 2009 - June 2010                                                                                                     |central      |                                   |
|122 |survey |DDI-IND-NSSO-66-SCHEDULE-1.0T1                            |Household Consumer Expenditure  Type-1, July 2009 - June 2010                                                                                             |central      |                                   |
|121 |survey |IND-NSSO-DTS-2008-v1                                      |Domestic Tourism Survey, July 2008 - June 2009                                                                                                            |central      |                                   |
|120 |survey |DDI-IND-MOSPI-NSSO-65Rnd-Sch1dot2-2008-09                 |Housing Condition Survey, July 2008- June  2009                                                                                                           |central      |                                   |
|119 |survey |DDI-IND-MOSPI-NSSO-65Rnd-Sch-0dot21-2008-09               |Urban Slums Survey , July 2008- June  2009                                                                                                                |central      |                                   |
|118 |survey |Schedule 25.2                                             |Participation and Expenditure in Education, 2007-08                                                                                                       |central      |                                   |
|117 |survey |IND-NSSO-EUMS-2007-v1                                     |Employment, Unemployment and Migration Survey, July 2007 - June 2008                                                                                      |EUE          |Employment and Unemployment        |
|116 |survey |IND-NSSO-HCES-2007-v1                                     |Household Consumer Expenditure Survey, July 2007-June 2008                                                                                                |central      |                                   |
|114 |survey |DDI-IND-MOSPI-NSSO-63Rnd-Sch1.0-2006-07                   |Household Consumer Expenditure, NSS 63rd Round : July 2006 - June 2007                                                                                    |CEXP         |Household Consumption Expenditure  |
|113 |survey |DDI-IND-MOSPI-NSSO-62nd-Sch10-2005-06                     |Employment and Unemployment Survey,  July 2005 - June 2006                                                                                                |EUE          |Employment and Unemployment        |
|112 |survey |DDI-IND-MOSPI-NSSO-62nd-Sch2dot2-LF-2005-06               |Unorganised Manufacturing Enterprises Survey [List Frame], July 2005 - June 2006                                                                          |central      |                                   |
|111 |survey |DDI-IND-MOSPI-NSSO-62nd-Sch2dot2-AF-2005-06               |Unorganised Manufacturing Enterprises Survey [AREA Frame]  : NSS 62nd Round : July 2005 - June 2006                                                       |central      |                                   |
|110 |survey |DDI-IND-MOSPI-NSSO-62Rnd-Sch1.0-2005-06                   |Household Consumer Expenditure, July 2005 - June 2006                                                                                                     |CEXP         |Household Consumption Expenditure  |
|109 |survey |DDI-IND-MOSPI-NSSO-61-12-2011                             |Employment and Unemployment, July 2004 - June 2005                                                                                                        |EUE          |Employment and Unemployment        |
|108 |survey |DDI-IND-MOSPI-NSSO-61Rnd-Sch1-July2004-June2005           |Household Consumer Expenditure,  July 2004 - June 2005                                                                                                    |CEXP         |Household Consumption Expenditure  |
|107 |survey |IND-NSSO-SMHC-2004-v1.0                                   |Survey on Morbidity and Health Care  January - June 2004                                                                                                  |OTH          |Other Surveys                      |
|106 |survey |DDI-IND-MOSPI-NSSO-60th-Sch10-2004                        |Employment and Unemployment Survey, January 2004 - June 2004                                                                                              |EUE          |Employment and Unemployment        |
|105 |survey |DDI-IND-MOSPI-NSSO-60Rnd-Sch1-Jan-June2004                |Household Consumer Expenditure, Jan - June 2004                                                                                                           |CEXP         |Household Consumption Expenditure  |
|104 |survey |IND-NSSO-59Rnd-Sch33-SAF-2003                             |Situation Assessment Survey of Farmers, 2003                                                                                                              |OTH          |Other Surveys                      |
|103 |survey |DDI-IND-MOSPI-NSSO-59Rnd-Sch18pt2-Jan-Dec2003             |Debt & Investment, Jan - Dec 2003                                                                                                                         |central      |                                   |
|102 |survey |DDI-IND-MOSPI-NSSO-59th-Sch18dot1-visit2-2003             |Land and Livestock Holdings Survey Visit 2: NSS 59th Round : January - December 2003                                                                      |central      |                                   |
|101 |survey |DDI-IND-MOSPI-NSSO-59th-Sch18dot1-visit1-2003             |Land and Livestock Holdings Survey Visit 1, January - December 2003                                                                                       |LLS          |Land and Livestock Holding Surveys |
|100 |survey |DDI-IND-MOSPI-NSSO-59Rnd-Sch1.0-2003                      |Household Consumer Expenditure, Jan 2003 - Dec 2003                                                                                                       |CEXP         |Household Consumption Expenditure  |
|99  |survey |DDI-IND-MOSPI-NSSO-58Rnd-Sch26-July2002-Dec2002           |Survey of disabled persons,  July 2002 - Dec 2002                                                                                                         |central      |                                   |
|98  |survey |IND-NSSO-58Rnd-Sch3.1-VF-2002                             |Village Facilities Survey , July 2002-December 2002                                                                                                       |central      |                                   |
|97  |survey |DDI-IND-MOSPI-NSSO-58Rnd-Sch1dot2-2002                    |Housing Condition Survey,  July - December 2002                                                                                                           |central      |                                   |
|96  |survey |DDI-IND-MOSPI-NSSO-58Rnd-Sch1.0-2002                      |Household Consumer Expenditure,  July 2002 - Dec 2002                                                                                                     |CEXP         |Household Consumption Expenditure  |
|95  |survey |DDI-IND-MOSPI-NSSO-58Rnd-Sch-0dot21-2002                  |Urban Slums Survey, July - December 2002                                                                                                                  |central      |                                   |
|94  |survey |IND-NSSO-57Rnd-Sch2.345-US-2002                           |Unorganised Service Sector: NSS 57th Round : July 2001-June 2002                                                                                          |central      |                                   |
|93  |survey |DDI-IND-MOSPI-NSSO-57Rnd-Sch1.0-2001                      |Household Consumer Expenditure, NSS 57th Round : July 2001 - June 2002                                                                                    |CEXP         |Household Consumption Expenditure  |
|92  |survey |IND-NSSO-56-Rnd-Sch2.2-UM-2000-01                         |Unorganised Manufacture :  July 2000-June 2001                                                                                                            |ENT          |Enterprises Surveys                |
|91  |survey |DDI-IND-MOSPI-NSSO-56Rnd-Sch1-July2000-June2001           |Household Consumer Expenditure, July 2000 - June 2001                                                                                                     |central      |                                   |
|90  |survey |DDI-IND-MOSPI-NSSO-55Rnd-Sch10-and-10dot1-1999-2000       |Employment and Unemployment Survey, July 1999 - June 2000                                                                                                 |central      |                                   |
|89  |survey |DDI-IND-MOSPI-NSSO-55Rnd-Sch2-1999-2000                   |Informal Non-Agricultural Enterprises Survey,  July 1999 - June 2000                                                                                      |ENT          |Enterprises Surveys                |
|88  |survey |DDI-IND-MOSPI-NSSO-55Rnd-Sch1-July1999-June2000           |Household Consumer Expenditure,  July 1999 - June 2000                                                                                                    |CEXP         |Household Consumption Expenditure  |
|87  |survey |IND-NSSO-CPRVF-1998-v01                                   |Common Property Resources and Village Facilities, January - June 1998                                                                                     |central      |                                   |
|86  |survey |DDI-IND-MOSPI-NSSO-54Rnd-Sch3pt3-Jan1998-June1998         |Common Property Resources & Village Facilities, NSS 54th Round : Jan 1998 - June 1998                                                                     |central      |                                   |
|85  |survey |DDI-IND-MOSPI-NSSO-54Rnd-Sch1.0-1998                      |Household Consumer Expenditure, Jan - June 1998                                                                                                           |CEXP         |Household Consumption Expenditure  |
|84  |survey |DDI-IND-MOSPI-NSSO-53Rnd-Sch2dot41dot2-1997               |Trade Survey , January 1997 - December 1997                                                                                                               |central      |                                   |
|83  |survey |DDI-IND-MOSPI-NSSO-53Rnd-Sch1.0-1997                      |Household Consumer Expenditure, Jan - Dec 1997                                                                                                            |CEXP         |Household Consumption Expenditure  |
|82  |survey |IND-MOSPI-NSSO-NSS-52-25.2-1995-V2.                       |Participation in Education,  July 1995 - July 1996                                                                                                        |central      |                                   |
|81  |survey |IND-NSSO-SHC-1995-v2.1                                    |Survey on Health Care  July - June 1995-96                                                                                                                |central      |                                   |
|80  |survey |DDI-IND-MOSPI-NSSO-52Rnd-Sch1.0-1995                      |Household Consumer Expenditure, July 1995 - June 1996                                                                                                     |central      |                                   |
|79  |survey |IND-NSSO-51-Rnd-Sch2.2-UM-1995                            |Unorganised Manufcture, July 1994-June 1995                                                                                                               |ENT          |Enterprises Surveys                |
|78  |survey |DDI-IND-MOSPI-NSSO-51Rnd-Sch1.0-1994                      |Household Consumer Expenditure,July 1994 - June 1995                                                                                                      |CEXP         |Household Consumption Expenditure  |
|77  |survey |DDI-IND-MOSPI-NSSO-50Rnd-Sch10-1993-94                    |Employment and Unemployment Survey, July 1993 - June 1994                                                                                                 |central      |                                   |
|76  |survey |DDI-IND-MOSPI-NSSO-50Rnd-Sch1.0-1993-94                   |Household Consumer Expenditure, July 1993 - June 1994                                                                                                     |central      |                                   |
|75  |survey |DDI-IND-MOSPI-NSSO-49Rnd-Sch1dot2-1993                    |Housing Condition and Migration Survey, January - June 1993                                                                                               |central      |                                   |
|74  |survey |DDI-IND-MOSPI-NSSO-49Rnd-Sch1.0-1993                      |Household Consumer Expenditure, Jan - June 1993                                                                                                           |CEXP         |Household Consumption Expenditure  |
|73  |survey |IND-NSSO-SS-1993-v1.0                                     |Slums Survey  January - June 1993                                                                                                                         |central      |                                   |
|72  |survey |DDI-IND-MOSPI-NSSO-48Rnd-Sch18dot1-visit2-1992            |Land and Livestock Holdings Survey: NSS 48th Round : January - December 1992:Visit-2                                                                      |LLS          |Land and Livestock Holding Surveys |
|71  |survey |DDI-IND-MOSPI-NSSO-48Rnd-Sch18dot1-visit1-1992            |Land and Livestock Holdings Survey: NSS 48th Round : January - December 1992:Visit-1                                                                      |LLS          |Land and Livestock Holding Surveys |
|70  |survey |IND-NSSO-DIS-1992-v1                                      |Debt and Investment Survey, January - December 1992, NSS 48th Round                                                                                       |central      |                                   |
|69  |survey |DDI-IND-MOSPI-NSSO-48Rnd-Sch1.0-1992                      |Household Consumer Expenditure, Jan - Dec 1992                                                                                                            |CEXP         |Household Consumption Expenditure  |
|68  |survey |IND-NSSO-SLC-1991-v1.0                                    |Survey on Literacy and Culture  July-December 1991                                                                                                        |central      |                                   |
|67  |survey |IND-NSSO-DMCS-1991-v1                                     |Developmental Milestones of Children Survey, July - Decemer 1991                                                                                          |central      |                                   |
|66  |survey |IND-NSSO-SDP-1991-v1.0                                    |Survey of Disabled Persons , July-Dec 1990                                                                                                                |central      |                                   |
|65  |survey |IND-NSSO-47Rnd-Sch3.1-VF-1991                             |Village Facilities Survey ,July - December 1991, NSS 47th Round                                                                                           |central      |                                   |
|64  |survey |DDI-IND-MOSPI-NSSO-47Rnd-Sch1.0-1991                      |Household Consumer Expenditure,  July - Dec 1991                                                                                                          |CEXP         |Household Consumption Expenditure  |
|63  |survey |IND-NSSO-TS-1990-91-v1.0                                  |Trade Survey: July-June 1990-91                                                                                                                           |ENT          |Enterprises Surveys                |
|62  |survey |DDI-IND-MOSPI-NSSO-46Rnd-Sch1.0-1990                      |Household Consumer Expenditure, July 1990 - Jun1991                                                                                                       |CEXP         |Household Consumption Expenditure  |
|61  |survey |IND-NSSO-45-Rnd-Sch2.2.2-UM-1989-90                       |Unorganised Manufacture,July 1989-June 1990                                                                                                               |ENT          |Enterprises Surveys                |
|60  |survey |DDI-IND-MOSPI-NSSO-45Rnd-Sch1.0-1989                      |Household Consumer Expenditure,  July 1989 - June 1990                                                                                                    |CEXP         |Household Consumption Expenditure  |
|59  |survey |IND-NSSO-SMOLNTTA-1988-v1.0                               |Survey on Migration and Ownership of Land by Non-Tribals in Trible Area July-June 1988-89                                                                 |central      |                                   |
|58  |survey |IND-NSSO-EAT-1988-v1                                      |Economic Activities of the Tribals, July 1988-June 1989                                                                                                   |central      |                                   |
|57  |survey |IND-NSSO-SLLT-1988-v1.0                                   |Survey on Level of Living of TRIBALS July-June 1988-89                                                                                                    |central      |                                   |
|56  |survey |IDDI-IND-MOSPI-4-EC-1998                                  |Fourth  Economic Census 1998                                                                                                                              |central      |                                   |
|55  |survey |DDI-IND-MOSPI-NSSO-43Rnd-Sch10-1987-88                    |Employment and Unemployment Survey: NSS 43rd Round : July 1987 - June 1988                                                                                |central      |                                   |
|54  |survey |DDI-IND-MOSPI-NSSO-43Rnd-Sch1.0-1987                      |Household Consumer Expenditure, July 1987 - June 1988                                                                                                     |central      |                                   |
|53  |survey |IND-NSSO-42ndRnd-Sch27-APS-1986-87                        |Persons Aged 60 Plus Survey: NSS 42nd Round Schedule 27  (1986-87)                                                                                        |central      |                                   |
|52  |survey |IND-NSSO-42ndRnd-Sch25.7-UMS-1986-87                      |Survey on  Utilisation of Medical Services ,   July 1986 - June 1987                                                                                      |central      |                                   |
|51  |survey |IND-NSSO-SPE-1986-v1.0                                    |Survey on Participation in Education July-June 1986-87                                                                                                    |central      |                                   |
|50  |survey |IND-NSSO-SMCCFPUPDS-1986-v1.0                             |Survey on Maternity,Child Care,Family Planning and Utilisation of Public Distribution System July-June 1986-87                                            |OTH          |Other Surveys                      |
|49  |survey |DDI-IND-MOSPI-NSSO-38Rnd-Sch10-1983                       |Employment and Unemployment Survey, January to December, 1983                                                                                             |EUE          |Employment and Unemployment        |
|48  |survey |DDI-IND-MOSPI-NSSO-38Rnd-Sch1.0-1983                      |Household Consumer Expenditure, January-December, 1983                                                                                                    |CEXP         |Household Consumption Expenditure  |
|47  |survey |DDI-IND-MOSPI-6-EC-2013-14                                |Sixth Economic Census 2013-14                                                                                                                             |central      |                                   |
|46  |survey |IDDI-IND-MOSPI-5-EC-2005                                  |Fifth Economic Census  2005                                                                                                                               |central      |                                   |
|45  |survey |IND-CSO-ASI-SUMMARY-94-95                                 |Annual Survey of Industries Summary 1994-95                                                                                                               |central      |                                   |
|44  |survey |IND-CSO-ASI-SUMMARY-93-94                                 |Annual Survey of Industries Summary 1993-94                                                                                                               |central      |                                   |
|43  |survey |IND-CSO-ASI-SUMMARY-92-93                                 |Annual Survey of Industries Summary 1992-93                                                                                                               |central      |                                   |
|42  |survey |IND-CSO-ASI-SUMMARY-91-92                                 |Annual Survey of Industries Summary 1991-92                                                                                                               |central      |                                   |
|41  |survey |IND-CSO-ASI-SUMMARY-90-91                                 |Annual Survey of Industries Summary 1990-91                                                                                                               |central      |                                   |
|40  |survey |IND-CSO-ASI-1989-90-v1                                    |Annual Survey of Industries 1989-90                                                                                                                       |central      |                                   |
|39  |survey |IND-CSO-ASI-SUMMARY-88-89                                 |Annual Survey of Industries Summary 1988-89                                                                                                               |central      |                                   |
|38  |survey |IND-CSO-ASI-SUMMARY-87-88                                 |Annual Survey of Industries Summary 1987-88                                                                                                               |central      |                                   |
|37  |survey |IND-CSO-ASI-SUMMARY-86-87                                 |Annual Survey of Industries Summary 1986-87                                                                                                               |central      |                                   |
|36  |survey |IND-CSO-ASI-SUMMARY-85-86                                 |Annual Survey of Industries Summary 1985-86                                                                                                               |central      |                                   |
|35  |survey |IND-CSO-ASI-SUMMARY-84-85                                 |Annual Survey of Industries Summary 1984-85                                                                                                               |central      |                                   |
|34  |survey |IND-CSO-ASI-SUMMARY-83-84                                 |Annual Survey of Industries Summary 1983-84                                                                                                               |central      |                                   |
|33  |survey |IND-CSO-ASI-SUMMARY-82-83                                 |Annual Survey of Industries Summary 1982-83                                                                                                               |central      |                                   |
|32  |survey |IND-CSO-ASI-SUMMARY-81-82                                 |Annual Survey of Industries Summary 1981-82                                                                                                               |central      |                                   |
|31  |survey |IND-CSO-ASI-SUMMARY-80-81                                 |Annual Survey of Industries Summary 1980-81                                                                                                               |central      |                                   |
|30  |survey |IND-CSO-ASI-SUMMARY-79-80                                 |Annual Survey of Industries Summary 1979-80                                                                                                               |central      |                                   |
|28  |survey |IND-CSO-ASI-SUMMARY-77-78                                 |Annual Survey of Industries Summary 1977-78                                                                                                               |central      |                                   |
|27  |survey |IND-CSO-ASI-SUMMARY-76-77                                 |Annual Survey of Industries Summary 1976-77                                                                                                               |central      |                                   |
|26  |survey |IND-CSO-ASI-2013-14                                       |Annual Survey of Industries 2013-14                                                                                                                       |ASI          |Annual Survey of Industries        |
|25  |survey |IND-CSO-ASI-2012-13                                       |Annual Survey of Industries 2012-13                                                                                                                       |ASI          |Annual Survey of Industries        |
|24  |survey |IND-CSO-ASI-2011-12-v1                                    |Annual Survey of Industries 2011-12                                                                                                                       |ASI          |Annual Survey of Industries        |
|23  |survey |IND-CSO-ASI-2010-11-v1                                    |Annual Survey of Industries 2010-11                                                                                                                       |ASI          |Annual Survey of Industries        |
|22  |survey |IND-CSO-ASI-2009-10-v1                                    |Annual Survey of Industries 2009-10                                                                                                                       |ASI          |Annual Survey of Industries        |
|21  |survey |IND-CSO-ASI-2008-09-v1                                    |Annual Survey of Industries 2008-09                                                                                                                       |ASI          |Annual Survey of Industries        |
|20  |survey |IND-CSO-ASI-2007-08-v1                                    |Annual Survey of Industries 2007-08                                                                                                                       |ASI          |Annual Survey of Industries        |
|19  |survey |IND-CSO-ASI-2006-07-v1                                    |Annual Survey of Industries 2006-07                                                                                                                       |ASI          |Annual Survey of Industries        |
|18  |survey |IND-CSO-ASI-2005-06-v1                                    |Annual Survey of Industries 2005-06                                                                                                                       |ASI          |Annual Survey of Industries        |
|17  |survey |IND-CSO-ASI-2004-05-v1                                    |Annual Survey of Industries 2004-05                                                                                                                       |ASI          |Annual Survey of Industries        |
|16  |survey |IND-CSO-ASI-2003-04-v1                                    |Annual Survey of Industries 2003-04                                                                                                                       |ASI          |Annual Survey of Industries        |
|15  |survey |IND-CSO-ASI-2002-03-v1                                    |Annual Survey of Industries 2002-03                                                                                                                       |ASI          |Annual Survey of Industries        |
|14  |survey |IND-CSO-ASI-2001-02-v1                                    |Annual Survey of Industries 2001-02                                                                                                                       |ASI          |Annual Survey of Industries        |
|13  |survey |IND-CSO-ASI-2000-01-v1                                    |Annual Survey of Industries 2000-01                                                                                                                       |ASI          |Annual Survey of Industries        |
|12  |survey |IND-CSO-ASI-1999-2000-v1                                  |Annual Survey of Industries 1999-2000                                                                                                                     |ASI          |Annual Survey of Industries        |
|11  |survey |IND-CSO-ASI-1998-99-v1                                    |Annual Survey of Industries 1998-99                                                                                                                       |ASI          |Annual Survey of Industries        |
|10  |survey |IND-CSO-ASI-1997-98-v1                                    |Annual Survey of Industries 1997-98                                                                                                                       |ASI          |Annual Survey of Industries        |
|9   |survey |IND-CSO-ASI-1996-97-v1                                    |Annual Survey of Industries 1996-97                                                                                                                       |ASI          |Annual Survey of Industries        |
|8   |survey |IND-CSO-ASI-1994-95                                       |Annual Survey of Industries 1994-95                                                                                                                       |ASI          |Annual Survey of Industries        |
|7   |survey |IND-CSO-ASI-1993-94-v1                                    |Annual Survey of Industries 1993-94                                                                                                                       |central      |                                   |
|6   |survey |IND-CSO-ASI-1989-90                                       |Annual Survey of Industries 1989-90                                                                                                                       |central      |                                   |
|5   |survey |IND-CSO-ASI-1984-85-v1                                    |Annual Survey of Industries 1984-85                                                                                                                       |central      |                                   |
|4   |survey |IND-CSO-ASI-1983-84-v1                                    |Annual Survey of Industries 1983-84                                                                                                                       |central      |                                   |
|3   |survey |IND-CSO-ASI-1974-v1                                       |Annual Survey of Industries Summary 1974-75                                                                                                               |central      |                                   |
|2   |survey |IND-CSO-ASI-2014-15                                       |Annual Survey of Industries 2014-15                                                                                                                       |ASI          |Annual Survey of Industries        |
|1   |survey |DDI-IND-MOSPI-NSSO-68Rnd-Sch1.0-July2011-June2012         |Household Consumer Expenditure, Type 1 : July 2011 - June 2012                                                                                            |central      |                                   |


### List files in a dataset

The `idno` column in the table above can be used to request the list
of files for a specific dataset.


```r
hces202223_files = list_files("DDI-IND-MOSPI-NSSO-HCES22-23")
hces202223_files
```


|name                                                |base64                                                               |size      |
|:---------------------------------------------------|:--------------------------------------------------------------------|:---------|
|DDI-IND-MOSPI-NSSO-HCES22-23.xml                    |RERJLUlORC1NT1NQSS1OU1NPLUhDRVMyMi0yMy54bWw=                         |1.65 MB   |
|HCES2022_Vol_I (1).pdf                              |SENFUzIwMjJfVm9sX0kgKDEpLnBkZg==                                     |3.19 MB   |
|HCES2022_Vol_II (1).pdf                             |SENFUzIwMjJfVm9sX0lJICgxKS5wZGY=                                     |3.39 MB   |
|HCES_2022_23_Imputation_rate (2).xlsx               |SENFU18yMDIyXzIzX0ltcHV0YXRpb25fcmF0ZSAoMikueGxzeA==                 |62.11 KB  |
|Layout_HCES 2022-23 (1).xlsx                        |TGF5b3V0X0hDRVMgMjAyMi0yMyAoMSkueGxzeA==                             |37.33 KB  |
|Objective of HCES (1).pdf                           |T2JqZWN0aXZlIG9mIEhDRVMgKDEpLnBkZg==                                 |183.02 KB |
|Readme_HCES2022 (1).docx                            |UmVhZG1lX0hDRVMyMDIyICgxKS5kb2N4                                     |19.45 KB  |
|Rider for users of unit level data of HCES (2).pdf  |UmlkZXIgZm9yIHVzZXJzIG9mIHVuaXQgbGV2ZWwgZGF0YSBvZiBIQ0VTICgyKS5wZGY= |110.83 KB |
|Survey methodology and estimation procedure (1).pdf |U3VydmV5IG1ldGhvZG9sb2d5IGFuZCBlc3RpbWF0aW9uIHByb2NlZHVyZSAoMSkucGRm |731.47 KB |
|tabulation_state_code (2).xlsx                      |dGFidWxhdGlvbl9zdGF0ZV9jb2RlICgyKS54bHN4                             |10.95 KB  |
|Unit level data of HCES 2022-23 round.zip           |VW5pdCBsZXZlbCBkYXRhIG9mIEhDRVMgMjAyMi0yMyByb3VuZC56aXA=             |116.95 MB |


### Download files

To download a specific file, one must specify both the `idno` and the
`base64` value in the table above. One must also explicitly specify
the destination file name (which need not be the same as the `name`
column in the table above) and optionally the destination folder.

```r
download_file(id = "DDI-IND-MOSPI-NSSO-HCES22-23",
              base64 = "dGFidWxhdGlvbl9zdGF0ZV9jb2RlICgyKS54bHN4",
              destfile = "./hces22-23/tabulation_state_code.xlsx")
download_file(id = "DDI-IND-MOSPI-NSSO-HCES22-23",
              base64 = "VW5pdCBsZXZlbCBkYXRhIG9mIEhDRVMgMjAyMi0yMyByb3VuZC56aXA=",
              destfile = "HCES-2022-23.zip",
              destfolder = "./hces22-23")
list.files("./hces22-23")
```

```
[1] "HCES-2022-23.zip"           "tabulation_state_code.xlsx"
```

