discover_photoshelter_galleries <- function(auth_token) {
  secrets <- jsonlite::read_json("secrets/appsettings.user.json")
  
  get_call <- httr::GET(url = "https://www.photoshelter.com/psapi/v3/mem/gallery/query",
                        query = list(parent = secrets[["target_collection_id"]]),
                        add_headers("X-PS-Api-Key" = secrets[["api_key"]],
                                    "X-PS-Auth-Token" = auth_token))
  
  get_response <- httr::content(get_call)
  if (get_response$status == "ok") {
    df <- purrr::map_df(get_response$data$Gallery, .f = function(row) { return(row) })
    return(df)
  }
  
  return(list())
}