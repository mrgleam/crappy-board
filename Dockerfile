FROM ghcr.io/gleam-lang/gleam:v1.4.1-erlang-alpine

# Add project code
COPY . /build/

# Compile the project
RUN cd /build \
&& gleam export erlang-shipment \
&& mv build/erlang-shipment /app \
&& rm -r /build \
&& addgroup -S crappy \
&& adduser -S crappy -G crappy \
&& chown -R crappy /app

# Run the application
USER crappy
WORKDIR /app
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["run"]