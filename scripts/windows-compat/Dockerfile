# Historical reference for a confirmed broken certificate in the 1.3.0 image.
# Not a default installation step. This generates new keys at build time.
FROM ghcr.io/usestrix/strix-sandbox:1.3.0
USER root
RUN openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 -sha256 -days 3650 -nodes \
      -keyout /app/certs/ca.key -out /app/certs/ca.crt \
      -subj "/CN=Strix Testing Root CA/O=Local Strix Sandbox" \
      -addext "basicConstraints=critical,CA:TRUE" \
      -addext "keyUsage=critical,keyCertSign,cRLSign,digitalSignature" \
      -addext "subjectKeyIdentifier=hash" \
    && openssl pkcs12 -export -out /app/certs/ca.p12 \
      -inkey /app/certs/ca.key -in /app/certs/ca.crt \
      -name "Strix Testing Root CA" -passout pass: \
      -keypbe AES-256-CBC -certpbe AES-256-CBC -macalg sha256 \
    && chown pentester:pentester /app/certs/ca.crt /app/certs/ca.key /app/certs/ca.p12 \
    && chmod 0644 /app/certs/ca.crt \
    && chmod 0600 /app/certs/ca.key /app/certs/ca.p12 \
    && cp /app/certs/ca.crt /usr/local/share/ca-certificates/ca.crt \
    && update-ca-certificates --fresh \
    && openssl verify -CAfile /etc/ssl/certs/ca-certificates.crt /app/certs/ca.crt
USER pentester
