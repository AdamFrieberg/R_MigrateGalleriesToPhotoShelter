library(dplyr)
library(purrr)

R.utils::sourceDirectory("R", modifiedOnly = FALSE)

migrate <- function() {
  auth_token <- authenticate_photoshelter()
  
  galleries_already_in_photoshelter <- discover_photoshelter_galleries(auth_token)
  galleries_local_on_disk <- discover_galleries_on_disk(parent_dir = "~/Downloads/GPhoto_Migrations")
  
  galleries_to_upload <- galleries_local_on_disk
  if (nrow(galleries_already_in_photoshelter) > 0) {
    galleries_to_upload <- galleries_local_on_disk %>%
      anti_join(galleries_already_in_photoshelter, by = c("gallery_name" = "name"))
  }
  
  pwalk(galleries_to_upload, .f = function(file_name, gallery_name, full_path) {
    image_locations <- unpack_zip(file_name, gallery_name, full_path)
    gallery_id <- create_photoshelter_gallery(auth_token, gallery_name)
    
    upload_images_to_photoshelter(auth_token, gallery_id, image_locations)
  })
}


migrate()