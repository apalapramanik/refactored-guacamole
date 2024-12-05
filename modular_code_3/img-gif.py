from PIL import Image, ImageSequence
import cairosvg
import os

def convert_svg_to_png(svg_path, output_path):
    """Converts an SVG file to PNG format."""
    cairosvg.svg2png(url=svg_path, write_to=output_path)

def convert_eps_to_png(eps_path, output_path):
    """Converts an EPS file to PNG format."""
    with Image.open(eps_path) as img:
        img.load(scale=10)  # High scale for better resolution
        img.save(output_path, format='PNG')

def create_gif(image_paths, output_path, duration=500):
    """Creates a GIF from a list of image paths."""
    frames = [Image.open(path) for path in image_paths]
    frames[0].save(
        output_path,
        save_all=True,
        append_images=frames[1:],
        duration=duration,
        loop=0
    )
    print(f"GIF saved at {output_path}")

# Paths to your SVG/EPS files
image_files = ["0.svg","1.svg", "3.svg", "4.svg", "5.svg", "6.svg"]
temp_png_files = []

# Convert SVG/EPS to PNG
for idx, img_file in enumerate(image_files):
    temp_png = f"temp_image_{idx}.png"
    temp_png_files.append(temp_png)
    
    if img_file.lower().endswith('.svg'):
        convert_svg_to_png(img_file, temp_png)
    elif img_file.lower().endswith('.eps'):
        convert_eps_to_png(img_file, temp_png)
    else:
        raise ValueError(f"Unsupported file format: {img_file}")

# Create GIF
create_gif(temp_png_files, "output.gif", duration=500)

# Clean up temporary PNG files (optional)
for temp_file in temp_png_files:
    os.remove(temp_file)
