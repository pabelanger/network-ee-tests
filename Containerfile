FROM quay.io/ansible/python-builder:latest as builder
# =============================================================================

ARG ZUUL_SIBLINGS=""
COPY . /tmp/src
RUN assemble

FROM quay.io/ansible/network-ee:latest as network-ee-base-tests
# =============================================================================

COPY --from=builder /output/ /output/
RUN /output/install-from-bindep \
  && rm -rf /output/

FROM network-ee-base-tests as network-ee-sanity-tests
# =============================================================================
CMD ["ansible-test", "sanity", "--python=3.8"]

FROM network-ee-base-tests as network-ee-unit-tests
# =============================================================================
CMD ["ansible-test", "units", "--python=3.8"]
