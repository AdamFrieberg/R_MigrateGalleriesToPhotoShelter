create_photoshelter_gallery <- function(auth_token,
                                        gallery_name,
                                        is_public = FALSE) {
  
  secrets <- jsonlite::read_json("secrets/appsettings.user.json")
  
  params <- list(name = gallery_name,
                 f_list = "f",
                 parent = secrets[["target_collection_id"]],
                 mode = ifelse(is_public, "permission", "private"))
  
  get_call <- httr::GET(url = "https://www.photoshelter.com/psapi/v3/mem/gallery/insert",
                        query = params,
                        add_headers("X-PS-Api-Key" = secrets[["api_key"]],
                                    "X-PS-Auth-Token" = auth_token))
  
  get_response <- httr::content(get_call)
  
  if (get_response$status == "ok") {
    return(get_response$data$Gallery$gallery_id)
  }
  
  return(NA_character_)
}