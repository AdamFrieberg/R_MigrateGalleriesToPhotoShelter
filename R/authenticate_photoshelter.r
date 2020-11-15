library(httr)
library(RCurl)

authenticate_photoshelter <- function() {
  secrets <- jsonlite::read_json("secrets/appsettings.user.json")
  
  body <- list(email = secrets[["photoshelter_email_address"]],
               password = secrets[["photoshelter_password"]],
               mode = "token")
  
  post_call <- httr::POST(url = "https://www.photoshelter.com/psapi/v3/mem/authenticate",
                            body = body,
                            add_headers("X-PS-Api-Key" = secrets[["api_key"]]),
                            encode = "form")
  
  post_response <- httr::content(post_call)
  
  if (post_response$status == "ok") {
    return(post_response$data$token)
  }
  
  stop("Failed to authenticate")
  return(NA_character_)
}