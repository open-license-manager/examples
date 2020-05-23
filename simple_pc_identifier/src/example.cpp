#include <iostream>
#include <map>
#include <licensecc/licensecc.h>

using namespace std;

int main(int argc, char *argv[]) {
	map<LCC_EVENT_TYPE, string> stringByEventType;
	stringByEventType[LICENSE_OK] = "OK ";
	stringByEventType[LICENSE_FILE_NOT_FOUND] = "license file not found ";
	stringByEventType[LICENSE_SERVER_NOT_FOUND] = "license server can't be contacted ";
	stringByEventType[ENVIRONMENT_VARIABLE_NOT_DEFINED] = "environment variable not defined ";
	stringByEventType[FILE_FORMAT_NOT_RECOGNIZED] = "license file has invalid format (not .ini file) ";
	stringByEventType[LICENSE_MALFORMED] = "some mandatory field are missing, or data can't be fully read. ";
	stringByEventType[PRODUCT_NOT_LICENSED] = "this product was not licensed ";
	stringByEventType[PRODUCT_EXPIRED] = "license expired ";
	stringByEventType[LICENSE_CORRUPTED] = "license signature didn't match with current license ";
	stringByEventType[IDENTIFIERS_MISMATCH] = "Calculated identifier and the one provided in license didn't match";

	LicenseInfo licenseInfo;
	size_t pc_id_sz = LCC_API_PC_IDENTIFIER_SIZE + 1;
	char pc_identifier[LCC_API_PC_IDENTIFIER_SIZE + 1];

	LCC_EVENT_TYPE result = acquire_license(nullptr, nullptr, &licenseInfo);

	if (result == LICENSE_OK) {
		cout << "license OK" << endl;
		if (!licenseInfo.linked_to_pc) {
			cout << "No hardware signature in license file. This is a 'demo' license that works on every pc." << endl
				 << "To generate a 'single pc' license call 'issue license' with option -s " << endl
				 << "and the hardware identifier obtained before." << endl
				 << endl;
		}
	}
	if (result != LICENSE_OK) {
		cout << "license ERROR :" << endl;
		cout << "    " << stringByEventType[result].c_str() << endl;
		if (identify_pc(STRATEGY_DEFAULT, pc_identifier, &pc_id_sz, nullptr)) {
			cout << "hardware id is :" << endl;
			cout << "    " << pc_identifier << endl;
		} else {
			cerr << "errors in identify_pc" << endl;
		}
	}

	return result;
}
