PACKAGE_NAME := tydhx.zip


clean:
	rm $(PACKAGE_NAME)
package:
	zip -r $(PACKAGE_NAME) tyd haxelib.json LICENSE README.md
install:
	haxelib install $(PACKAGE_NAME)
submit:
	haxelib submit $(PACKAGE_NAME)