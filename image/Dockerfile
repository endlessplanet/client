FROM docker:17.07.0-ce
COPY root /opt/docker/
RUN ["sh", "/opt/docker/run.sh"]
USER user
ENTRYPOINT ["sh", "/opt/docker/entrypoint.sh"]
CMD []