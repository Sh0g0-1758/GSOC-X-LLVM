import os
from PIL import Image
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import letter

def combine_images_to_pdf(input_folder, output_pdf):
    # Get all PNG files in the folder
    png_files = [f for f in os.listdir(input_folder) if f.lower().endswith('.png')]
    png_files.sort()  # Optional: sort files alphabetically

    # Check if there are any PNG files
    if not png_files:
        print("No PNG files found in the folder.")
        return

    # Create a new PDF with ReportLab
    c = canvas.Canvas(output_pdf, pagesize=letter)
    width, height = letter  # Default PDF page size (8.5 x 11 inches)

    for png_file in png_files:
        image_path = os.path.join(input_folder, png_file)
        # Open the image
        img = Image.open(image_path)
        # Convert the image to RGB if it's in a different mode (e.g., RGBA)
        if img.mode != 'RGB':
            img = img.convert('RGB')

        # Calculate the image dimensions to fit into the PDF page size
        img_width, img_height = img.size
        aspect_ratio = img_width / img_height
        new_width = width
        new_height = width / aspect_ratio

        if new_height > height:
            new_height = height
            new_width = height * aspect_ratio

        x_offset = (width - new_width) / 2
        y_offset = (height - new_height) / 2

        # Add the image to the PDF
        c.drawImage(image_path, x_offset, y_offset, new_width, new_height)
        c.showPage()  # Add a new page in the PDF for each image

    c.save()  # Save the PDF
    print(f"PDF saved as {output_pdf}")

if __name__ == "__main__":
    input_folder = "./correlation_analysis"  # Replace with the path to your folder
    output_pdf = "result.pdf"  # Replace with the desired output PDF name
    combine_images_to_pdf(input_folder, output_pdf)
