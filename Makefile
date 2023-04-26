DRAFT	:= $(basename $(wildcard draft-*.md))
VERSION	:= $(shell sed -n -e'/docname/s,.*[^0-9]*-\([0-9]*\).*,\1,p' ${DRAFT}.md )
EXAMPLES =
EMAIL	= aland@freeradius.org

${DRAFT}-${VERSION}.txt: ${DRAFT}.txt
	@cp ${DRAFT}.txt ${DRAFT}-${VERSION}.txt

#	: git add ${DRAFT}-${VERSION}.txt ${DRAFT}.txt

%.xml: %.md ${EXAMPLES}
	@kramdown-rfc2629 -3 ${DRAFT}.md > ${DRAFT}.xml
	@xml2rfc --v2v3 ${DRAFT}.xml
	@mv ${DRAFT}.v2v3.xml ${DRAFT}.xml

%.txt: %.xml
	@xml2rfc --text -o $@ $?

%.html: %.xml
	@xml2rfc --html -o $@ $?

submit: ${DRAFT}.xml
	@curl -S -F "user=${EMAIL}" -F "xml=@${DRAFT}.xml" https://datatracker.ietf.org/api/submit
	@git tag ${DRAFT}-${VERSION}

version:
	@echo Version: ${VERSION}

clean:
	@rm -f *.xml *~

.PRECIOUS: ${DRAFT}.xml
