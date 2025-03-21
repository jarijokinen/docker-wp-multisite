# docker-wp-multisite

WordPress Multisite Docker image with Debian (stable-slim), Nginx and PHP-FPM.

## Usage

### Example: Creating a custom image based on this image

Directory structure:

```plaintext
.
├── Dockerfile
├── src
│   ├── plugins                             # Plugins to copy to the image
│   │   └── elementor-pro-3.28.0.zip
│   ├── themes                              # Themes to copy to the image
│   │   └── my-custom-theme.zip
│   └── init-custom-site.sh                 # Entrypoint script
└── compose.yml
```

Dockerfile:

```Dockerfile
FROM jarijokinen/wp-multisite:latest

COPY ./src/themes /themes
COPY ./src/plugins /plugins

COPY ./src/init-custom-site.sh ./init-custom-site.sh
RUN chmod 700 ./init-custom-site.sh

ENTRYPOINT ["/init-custom-site.sh"]
```

src/init-custom-site.sh:

```bash
#!/bin/bash

# Call the entrypoint script of the parent image
DISABLE_FOREGROUND=1 ./init-wp.sh

# Copy plugins and themes

for zipfile in /plugins/*.zip; do
  unzip "$zipfile" -d /wp/wp-content/plugins/
  rm "$zipfile"
done

for zipfile in /themes/*.zip; do
  unzip "$zipfile" -d /wp/wp-content/themes/
  rm "$zipfile"
done

# Install plugins and themes from the WordPress repository

plugins=(
  elementor
  generateblocks
  kadence-blocks
  kadence-starter-templates
)

for plugin in "${plugins[@]}"; do
  wget -q "https://downloads.wordpress.org/plugin/$plugin.latest-stable.zip" \
    -O "/tmp/$plugin.zip"
  unzip "/tmp/$plugin.zip" -d /wp/wp-content/plugins/
  rm "/tmp/$plugin.zip"
done

themes=(
  astra
  generatepress
  hello-elementor
  kadence
)

for theme in "${themes[@]}"; do
  wget -q "https://downloads.wordpress.org/theme/$theme.latest-stable.zip" \
    -O "/tmp/$theme.zip"
  unzip "/tmp/$theme.zip" -d /wp/wp-content/themes/
  rm "/tmp/$theme.zip"
done

chown -R wp:wp /wp/wp-content

# Prevent the container from exiting
tail -f /dev/null

exit 0
```

## License

MIT License. Copyright (c) 2025 [Jari Jokinen](https://jarijokinen.com). See
[LICENSE](https://github.com/jarijokinen/docker-wp-multisite/blob/main/LICENSE.txt) for further details.
