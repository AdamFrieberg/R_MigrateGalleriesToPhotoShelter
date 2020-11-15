unpack_zip <- function(file_name, gallery_name, full_path) {
  extracted_dir <- file.path("extracted", gallery_name)
  fs::dir_create(extracted_dir)
  
  extracted_paths <- unzip(full_path, exdir = extracted_dir )
  return(extracted_paths)
}