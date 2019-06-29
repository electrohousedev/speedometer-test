compile_files('scripts/**.lua')

build_images  'images' 
build_atlas( 'images', '**' , 'atlas' , 128, 128 )


copy_files('fonts/*.lua')
premultiply_images('fonts/*.png')

