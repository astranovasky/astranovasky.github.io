# Use Ruby 3.0.4 because it builds EventMachine successfully
FROM ruby:3.0.4

# Install system dependencies required for Jekyll and native gem extensions
RUN apt-get update && apt-get install -y \
  build-essential \
  libffi-dev \
  libssl-dev \
  nodejs \
  && rm -rf /var/lib/apt/lists/*

# Update Rubygems to at least 3.3.22 (we'll update to 3.3.25 here)
RUN gem update --system 3.3.25

# Set the working directory inside the container
WORKDIR /app

# Copy Gemfile and Gemfile.lock first (for caching)
COPY Gemfile Gemfile.lock ./

# Install bundler and project gems
RUN gem install bundler && bundle install

# Copy the rest of your site’s code into the container
COPY . .

# Expose port 4000 (default Jekyll port)
EXPOSE 4000

# Command to serve your site, binding to all interfaces
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0"]
