# Extract Van Gogh Paintings Code Challenge

## Project Overview 🪴

This Ruby-based application is developed to extract specific information from a Google Scrolling Carousel embedded within an HTML file. It aims to collect the following details:

- the painting's title,
- an array of extensions ( the date the painting was created ),
- encoded thumbnail data, and
- the associated Google search link.

The gathered information is compiled into a JSON array and exported for convenient use.

## Technology Stack 💻

- **Ruby**: Core programming language
- **Nokogiri**: HTML parsing
- **Watir**: Headless browser functionality
- **RSpec**: Testing framework
- **MiniMagick & Base64**: Comparing encoded images with expected data

## Features 🚀

- **Precise Extraction:** Accurately extracts painting names, dates, encoded thumbnail data, and Google search links.
- **Handles Edge Cases:** Manages placeholders and non-visible images gracefully.
- **Adaptable:** Able to extract data for various HTML file structures that use Google's scrolling carousel.
- **Flexible Output:** Exports extracted data as a convenient JSON array. Gives the option to only extract specific indexes by passing an index array to the `extract` method
- **Demo & Development Tools:** Includes scripts for easy experimentation and setup (bin/demo, bin/setup, bin/console).

## Install 📥

### Clone the repository

#### Cloning from forked branch

```bash
git clone git@github.com:acasarsa/serpapi-code-challenge.git
cd serpapi-code-challenge
git checkout andrew-casarsa-code-challenge-solution-v1
```

### Set bin permissions

There are several automated bin scripts to help help with install, demoing and running the program. \
To ensure that bin directory scripts are executable s permissions using the following command:

```shell
chmod +x bin/*
```

### Install dependencies

use convenient `bin/bash` command to install dependencies or `bundle install`

```bash
bin/setup
```

## Run Tests 🧪

Run tests to see that all pass

```shell
bundle exec rspec
```

## Usage 🛠️

### Basic Extraction

This will generate an `output_data.json` file with the extracted data. Run it with the default file_path or get the `relative_path` for `salvador-dali-paintings.html` and run it with that.

```bash
bin/run
bin/run spec/fixtures/salvador-dali-paintings.html
```

### Demo / Playground

The `bin/demo` script provides a pre-configured Pry console with 2 extractors instantiated with different HTML files for user experimentation.

```bash
bin/demo
```

### Console

To open a console with project-specific settings, use:

```bash
bin/console
```

# Core Functionality 💪

### Parsing and Extraction Process

The extraction process is the heart of the application, enabling users to extract specific details from HTML files containing a Google Scrolling Carousel.

**Execution with `bin/run`:**

- The main script `bin/run` initiates the extraction process. It utilizes the `HtmlFileParser` class, which employs Watir's `BrowserService` for handling headless browser operations. This setup ensures that any JavaScript on the page is executed, allowing for accurate parsing.
- The `HtmlFileParser` takes an HTML file path as input and uses Nokogiri to parse the HTML content, enhanced by Watir's browser service to manage JavaScript-rendered content.

**Data Extraction:**

- The `CarouselExtractor` class processes the parsed document to identify relevant elements within the Google Scrolling Carousel. It extracts key details such as the painting's name, the date of the painting that is put into an extensions array, the encoded thumbnail image, and the Google search link associated with each artwork.
- Placeholder images and non-visible images are handled with specific logic: images marked for lazy loading (via `data-src`) or placeholders are returned as `nil` to avoid unnecessary data extraction or extra HTTP requests.

**Output:**

- The extracted information is compiled into a structured array of hashes. Each hash represents an artwork, containing attributes like 'name', 'link', 'extensions': [such as date], and 'image'.
- This array is then exported to a JSON file for easy usage.

## Customization and Flexibility 🎨

The project can be extended to handle different types of Google Scrolling Carousels by adding more robust fallback methods and handling different edge cases as needed.

- A fallback method is implemented for extracting dates when the expected class (.ellip) is missing or if the whole date div is missing.
- I also added a logger.warn to log whenever the fallback was needed. I would extend this sort of behavior to a monitoring system to help track html changes that could break the app.

- A similar approach could be employed to manage the "View all" link in some carousels by checking for `role='link'` or verifying the `.text` content.

## Development Experience 💡

The project presented a rich problem-solving experience, especially in handling edge cases like image data extraction. The Test-Driven Development (TDD) approach proved invaluable in ensuring robust and reliable extraction logic.

## Next Steps 🪜

Consider implementing further monitoring capabilities, such as logging warnings for potential issues or integrating with tools like Sentry for error tracking.

## Contributing 🤝

Feel free to submit issues or pull requests if you find any bugs or have suggestions for improvements.

## License 📄

This project is licensed under the MIT License.
