#include <iostream>
#include <unordered_map>
#include <licensecc/licensecc.h>

using namespace std;

int main(int argc, char *argv[]) {
	unordered_map<LCC_EVENT_TYPE, string> stringByEventType = {
		{LICENSE_OK, "OK "},
		{LICENSE_FILE_NOT_FOUND, "license file not found "},
		{LICENSE_SERVER_NOT_FOUND, "license server can't be contacted "},
		{ENVIRONMENT_VARIABLE_NOT_DEFINED, "environment variable not defined "},
		{FILE_FORMAT_NOT_RECOGNIZED, "license file has invalid format (not .ini file) "},
		{LICENSE_MALFORMED, "some mandatory field are missing, or data can't be fully read. "},
		{PRODUCT_NOT_LICENSED, "this product was not licensed "},
		{PRODUCT_EXPIRED, "license expired "},
		{LICENSE_CORRUPTED, "license signature didn't match with current license "},
		{IDENTIFIERS_MISMATCH, "Calculated identifier and the one provided in license didn't match"}};

	LicenseInfo licenseInfo;
	size_t pc_id_sz = LCC_API_PC_IDENTIFIER_SIZE + 1;
	char pc_identifier[LCC_API_PC_IDENTIFIER_SIZE + 1];

	LCC_EVENT_TYPE result = acquire_license(nullptr, nullptr, &licenseInfo);

	if (result == LICENSE_OK) {
		cout << "license for main software OK" << endl;
	} else {
		cout << "license ERROR :" << endl;
		cout << "    " << stringByEventType[result].c_str() << endl;
		if (identify_pc(STRATEGY_DEFAULT, pc_identifier, &pc_id_sz, nullptr)) {
			cout << "pc signature is :" << endl;
			cout << "    " << pc_identifier << endl;
		} else {
			cerr << "errors in identify_pc" << endl;
		}
		return -1;
	}
	// Call the software
	CallerInformations callerInfo = {"\0", "MY_AWESOME_FUNC"};
	result = acquire_license(&callerInfo, nullptr, &licenseInfo);

	if (result == LICENSE_OK) {
		cout << "MY_AWESOME_FUNC is licensed" << endl;
	} else {
		cout << "MY_AWESOME_FUNC is NOT licensed" << endl;
	}

	return result;
}
