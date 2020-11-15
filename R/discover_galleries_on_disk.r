discover_galleries_on_disk <- function(parent_dir) {
  parent_dir_path <- fs::as_fs_path(parent_dir)

  zip_paths <- list.files(parent_dir_path, pattern = ".zip", full.names = TRUE)
  
  zip_df <- purrr::map_df(zip_paths,
                          .f = function(p) {
                            gallery_components <- data.frame(file_name = fs::path_file(p),
                                                             gallery_name = tools::file_path_sans_ext(fs::path_file(p)),
                                                             full_path = p)
                            
                            return(gallery_components)
                          })
}