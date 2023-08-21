# from PIL import Image

# # Open the image file
# input_image_path = './turn_plus.png'  # Replace with the path to your input image
# output_image_path = 'output_image.png'  # Replace with the path for the output image
# color_to_fill = (196, 154, 108, 255)  # RGBA color tuple for "#c49a6c"

# # Open the image with transparency support
# image = Image.open(input_image_path).convert('RGBA')

# # Get the dimensions of the image
# width, height = image.size

# # Create a new image with the same dimensions and initialize it with transparent pixels
# output_image = Image.new('RGBA', (width, height), (0, 0, 0, 0))

# # Loop through each pixel and update it if it's not transparent
# for x in range(width):
#     for y in range(height):
#         r, g, b, a = image.getpixel((x, y))
#         if a == 0:  # Check if the pixel is not transparent
#             output_image.putpixel((x, y), color_to_fill)
#         else:  # Preserve transparency for transparent pixels
#             output_image.putpixel((x, y), (0, 0, 0, 0))

# # Save the new image
# output_image.save(output_image_path)

# print(f"All non-transparent pixels in the image changed to color {color_to_fill} and saved to {output_image_path}")

from PIL import Image

# Open the image file
input_image_path = './turn_minus.png'  # Replace with the path to your input image
output_image_path = 'output_image.png'  # Replace with the path for the output image
color_to_fill = (196, 154, 108, 255)  # RGBA color tuple for "#c49a6c"

# Open the image with transparency support
image = Image.open(input_image_path).convert('RGBA')


width, height = image.size

# Create a new image with the same dimensions and initialize it with transparent pixels
output_image = Image.new('RGBA', (width, height), (0, 0, 0, 0))

# Loop through each pixel and update it if it's not fully transparent
for x in range(width):
    for y in range(height):
        r, g, b, a = image.getpixel((x, y))
        if a == 0:  # Check if the pixel is fully transparent
            output_image.putpixel((x, y), (0, 0, 0, 0))
        else: 
            output_image.putpixel((x, y), color_to_fill)


output_image.save(output_image_path)

print(f"All pixels except fully transparent ones changed to color {color_to_fill} and saved to {output_image_path}")

