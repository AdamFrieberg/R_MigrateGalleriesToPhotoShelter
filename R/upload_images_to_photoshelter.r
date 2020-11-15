upload_images_to_photoshelter <- function(auth_token, gallery_id, image_locations) {
  secrets <- jsonlite::read_json("secrets/appsettings.user.json")
  
  purrr::walk(image_locations, .f = function(loc) {
    body <- list(file = upload_file(loc),
                 gallery_id = gallery_id,
                 f_searchable = "f")
    
    post_call <- httr::POST(url = 'https://www.photoshelter.com/psapi/v3/mem/image/upload',
                            body = body,
                            add_headers("X-PS-Api-Key" = secrets[["api_key"]],
                                        "X-PS-Auth-Token" = auth_token),
                            encode = "multipart")
  
    post_response <- httr::content(post_call)
    
    if (post_response$status != "ok") {
      l <- list(
        gallery_id = gallery_id,
        image_location = loc
      )
      jsonlite::write_json(l, paste0(system("uuidgen", intern=T), ".json"))
    }
  })
}