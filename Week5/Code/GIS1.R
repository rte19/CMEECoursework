library(raster) #Core raster GIS data package
library(sf) #Core vector GIS data package
library(viridis) #Because we like the clolour scheme
library(units) 

#Creating a population density map of the British Isles
pop_dens <- data.frame(n_km2 = c(260, 67, 151, 4500, 133), country=c("England", "Scotland", "Wales", "London", "Northern Ireland"))
print(pop_dens)
##   n_km2  country
## 1 260    England
## 2  67    Scotland
## 3 151    Wales
## 4 4500   London
## 5 133    Northern Ireland

# Create coordinates  for each country 
# -  this is a list of sets of coordinates forming the edge of the polygon. 
# - note that they have to _close_ (have the same coordinate at either end)
scotland <- rbind(c(-5, 58.6), c(-3, 58.6), c(-4, 57.6), 
                  c(-1.5, 57.6), c(-2, 55.8), c(-3, 55), 
                  c(-5, 55), c(-6, 56), c(-5, 58.6))
england <- rbind(c(-2,55.8),c(0.5, 52.8), c(1.6, 52.8), 
                 c(0.7, 50.7), c(-5.7,50), c(-2.7, 51.5), 
                 c(-3, 53.4),c(-3, 55), c(-2,55.8))
wales <- rbind(c(-2.5, 51.3), c(-5.3,51.8), c(-4.5, 53.4),
               c(-2.8, 53.4),  c(-2.5, 51.3))
ireland <- rbind(c(-10,51.5), c(-10, 54.2), c(-7.5, 55.3),
                 c(-5.9, 55.3), c(-5.9, 52.2), c(-10,51.5))

# Convert these coordinates into feature geometries
# - these are simple coordinate sets with no projection information
scotland <- st_polygon(list(scotland))
england <- st_polygon(list(england))
wales <- st_polygon(list(wales))
ireland <- st_polygon(list(ireland))

#Combine geometries into a simple feature column
uk_eire <- st_sfc(wales, england, scotland, ireland, crs=4326)
plot(uk_eire, asp=1)

#Point vector data for cpital cities
uk_eire_capitals <- data.frame(long= c(-0.1, -3.2, -3.2, -6.0, -6.25),
                               lat=c(51.5, 51.5, 55.8, 54.6, 53.30),
                               name=c("London", "Cardiff", "Edinburgh", "Belfast", "Dublin"))
uk_eire_capitals <- st_as_sf(uk_eire_capitals, coords=c("long", "lat"), crs=4326)

#Make London anywhere within a quarter degree of St. Pauls Cathedral
st_pauls <- st_point(x=c(-0.098056, 51.513611))
london <- st_buffer(st_pauls, 0.25)

#Setting a different population density for london compared with england
england_no_london <- st_difference(england, london)

#Count the points and show the number of rings within the polygon features
lengths(scotland)
lengths(england_no_london)

#Tidying up Wales
wales <- st_difference(wales, england)

#Using intersection operation to separate Northern Ireland from Ireland
#A rough polygon that includes Northern Ireland and surrounding sea
# - not the alternative way of providing the coordinates
ni_area <- st_polygon(list(cbind(x=c(-8.1, -6, -5, -6, -8.1),
                                y=c(54.4, 56, 55, 54, 54.4))))
northern_ireland <- st_intersection(ireland, ni_area)
eire <- st_difference(ireland, ni_area)

#Combine the fnal geometries
uk_eire <- st_sfc(wales, england_no_london, scotland, london, northern_ireland, eire, crs=4326)

#Make the UK into a single feature
uk_country <- st_union(uk_eire[-6])
#Compare six polygon features with one multipolygon feature
print(uk_eire)
print(uk_country)

#Plot them
par(mfrow=c(1, 2), mar=c(3, 3, 1, 1))
plot(uk_eire, asp=1, col=rainbow(6))
plot(st_geometry(uk_eire_capitals), add=TRUE)
plot(uk_country, asp=1, col="lightblue")

#The sf package introduces the sf object type: basically this is just a
#normal data frame with an additional simple feature column
uk_eire <- st_sf(name=c("wales", "england", "scotland", "london", "northern_ireland", "eire"),
                 geometry=uk_eire)
plot(uk_eire, asp=1)

#Can add attributes to the sf object by adding fields directly
uk_eire$capital <- c("london", "edinburgh", "cardiff", NA, "Belfast", "Dublin")

#Can use the merge command to match data in Note that we need to use by.x 
#and by.y to say which columns we expect to match. We also use all.x=TRUE, 
#otherwise Eire will be dropped from the spatial data because it has no 
#population density estimate in the data frame.
uk_eire <- merge(uk_eire, pop_dens, by.x="name", by.y="country", all.x=TRUE)
print(uk_eire)


#We might want some spatial attributes, like the centroids
uk_eire_centroids <- st_centroid(uk_eire)
st_coordinates(uk_eire_centroids)

#Finding out the lengths and areas of places
uk_eire$area <- st_area(uk_eire)
#The length iof a polygon is the perimenter length, including lengths of internal holes
uk_eire$length <- st_length(uk_eire)
print(uk_eire)

#You can change units in a neat way
uk_eire$area <- set_units(uk_eire$area, "km^2")
uk_eire$length <- set_units(uk_eire$length, "km")

uk_eire$length <- as.numeric(uk_eire$length)
print(uk_eire)

#Distance between objects
st_distance(uk_eire)
st_distance(uk_eire_centroids)

#Plotting sf objects
plot(uk_eire["n_km2"], asp=1)
# You could simply log the data:
uk_eire$log_n_km2 <- log10(uk_eire$n_km2)
plot(uk_eire['log_n_km2'], asp=1)
# Or you can have logarithimic labelling using logz
plot(uk_eire['n_km2'], asp=1, logz=TRUE)


#Reprojecting vector data
#British National Grid (EPSG:27700)
uk_eire_BNG <- st_transform(uk_eire, 27700)
st_bbox(uk_eire)
st_bbox(uk_eire_BNG)
uk_eire_UTM50N <- st_transform(uk_eire, 32650)

par(mfrow=c(1, 3), mar=c(3,3,1,1))
plot(st_geometry(uk_eire), asp=1, axes=TRUE, main="WGS 84")
plot(st_geometry(uk_eire_BNG), axes=TRUE, main="OSGB 1936 / BNG")
plot(st_geometry(uk_eire_UTM50N), aexes=TRUE, main="UTM 50N")

#Set up some points separated by 1 degree latitude and longitude from St. Pauls
st_pauls <- st_sfc(st_pauls, crs = 4326)
one_deg_west_pt <- st_sfc(st_pauls - c(1, 0), crs=4326) #near Goring
one_deg_north_pt <- st_sfc(st_pauls + c(0, 1), crs=4326) #near Peterborough
#Calculate the distance between St Pauls and each point
st_distance(st_pauls, one_deg_west_pt)
st_distance(st_pauls, one_deg_north_pt)

# transform St Pauls to BNG and buffer using 25 km
london_bng <- st_buffer(st_transform(st_pauls, 27700), 25000)
# In one line, transform england to BNG and cut out London
england_not_london_bng <- st_difference(st_transform(st_sfc(england, crs=4326), 27700), london_bng)
# project the other features and combine everything together
others_bng <- st_transform(st_sfc(eire, northern_ireland, scotland, wales, crs=4326), 27700)
corrected <- c(others_bng, london_bng, england_not_london_bng)
# Plot that and marvel at the nice circular feature around London
par(mar=c(3,3,1,1))
plot(corrected, main='25km radius London', axes=TRUE)

#Creating a raster
#Create an empty raster object covering UK and Eire
uk_raster_WGS84 <- raster(xmn=-11, xmx=2, ymn=49.5, ymx=59,
                          res=0.5, crs="+init=EPSG:436")
hasValues(uk_raster_WGS84)
#Add data to the raster: just the number 1 to number of cells
values(uk_raster_WGS84) <- seq(length(uk_raster_WGS84))

par(mfrow=c(1, 1))
plot(uk_raster_WGS84)
plot(st_geometry(uk_eire), add=TRUE, border='black', lwd=2, col='#FFFFFF44')


#Changing raster resolution
#Define a simple 4x4 square raster
m <- matrix(c(1, 1, 3, 3,
              1, 2, 4, 3,
              5, 5, 7, 8,
              6, 6, 7, 7), ncol=4, byrow = TRUE)
square <- raster(m)

#Aggregating rasters
#Average values
square_agg_mean <- aggregate(square, fact=2, fun=mean)
values(square_agg_mean)
#Maximum values
square_agg_max <- aggregate(square, fact=2, fun=max)
values(square_agg_max)
#Modal values for categories
square_agg_modal <- aggregate(square, fact=2, fun=modal)
values(square_agg_modal)


#Disaggregating rasters
#Copy parents
square_disagg <- disaggregate(square, fact=2)
#Interpolate
square_disagg_interp <- disaggregate(square, fact=2, method="bilinear")


#Reprojecting a raster
#Make two simple 'sfc' objects containing points in the lower left and top
#right of the two grids
uk_pts_WGS84 <- st_sfc(st_point(c(-11, 49.5)), st_point(c(2, 59)), crs=4326)
uk_pts_BNG <- st_sfc(st_point(c(-2e5, 0)), st_point(c(7e5, 1e6)), crs=27700)

#Use st_make_grid to quickly create a polygon grid with the right cell size
uk_grid_WGS84 <- st_make_grid(uk_pts_WGS84, cellsize=0.5)
uk_grid_BNG <- st_make_grid(uk_pts_BNG, cellsize = 1e5)

#Reproject BNG grid into WGS84
uk_grid_BNG_as_WGS84 <- st_transform(uk_grid_BNG, 4326)

#Plot the features
plot(uk_grid_WGS84, asp=1, border="grey", xlim=c(-13, 4))
plot(st_geometry(uk_eire), add=TRUE, border="darkgreen", lwd = 2)
plot(uk_grid_BNG_as_WGS84, border="red", add=TRUE)

#Create the target raster
uk_raster_BNG <- raster(xmn=-200000, xmx=700000, ymn=0, ymx=1000000,
                        res=100000, crs="+init=EPSG:27700")
uk_raster_BNG_interp <- projectRaster(uk_raster_WGS84, uk_raster_BNG, method = "bilinear")
