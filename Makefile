PACKAGE_NAME := tydhx.zip


clean:
	rm $(PACKAGE_NAME)
package:
	zip -r $(PACKAGE_NAME) tyd haxelib.json LICENSE README.md
submit:
	haxelib submit $(PACKAGE_NAME)