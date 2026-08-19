#include <iostream>
#include <unordered_map>
#include <licensecc/licensecc.h>
#include <string.h>
using namespace std;

int main(int argc, char* argv[]) {
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

	unordered_map<LCC_API_VIRTUALIZATION_DETAIL, string> stringByVirtDetail = {{BARE_TO_METAL, "Bare-to-metal"},
																			   {VMWARE, "VMware"},
																			   {VIRTUALBOX, "VirtualBox"},
																			   {QEMU, "QEMU"},
																			   {V_XEN, "Xen"},
																			   {KVM, "KVM"},
																			   {HV, "Microsoft Hyper-V"},
																			   {PARALLELS, "Parallels"},
																			   {V_OTHER, "Other virtualization"}};

	unordered_map<LCC_API_CLOUD_PROVIDER, string> stringByCloudProvider = {
		{PROV_UNKNOWN, "Unknown / Not a cloud provider"},
		{ON_PREMISE, "On-premise"},
		{GOOGLE_CLOUD, "Google Cloud Platform"},
		{AZURE_CLOUD, "Microsoft Azure"},
		{AWS, "Amazon Web Services"},
		{ALI_CLOUD, "Alibaba Cloud"}};

	unordered_map<LCC_API_VIRTUALIZATION_SUMMARY, string> stringByVirtSummary = {
		{NONE, "No virtualization (bare metal)"}, {CONTAINER, "Container"}, {VM, "Virtual machine"}};

	LicenseInfo licenseInfo;
	/**
	 * This structure will contain the information about the execution environment (bare to metal, vm, cloud)...
	 */
	ExecutionEnvironmentInfo execEnvInfo;

	LCC_EVENT_TYPE result = acquire_license(nullptr, nullptr, &licenseInfo);

	if (result == LICENSE_OK) {
		cout << "license OK" << endl;
		if (!licenseInfo.linked_to_pc) {
			cout << "No hardware signature in license file. This is a 'demo' license that works on every pc." << endl
				 << "To generate a 'single pc' license call 'issue license' with option -s " << endl
				 << "and the hardware identifier obtained before." << endl;
		}
	}
	if (result != LICENSE_OK) {
		size_t pc_id_sz = LCC_API_PC_IDENTIFIER_SIZE;
		char pc_identifier[LCC_API_PC_IDENTIFIER_SIZE];
		cout << "license ERROR :" << endl;
		cout << "    " << stringByEventType[result].c_str() << endl;
		if (identify_pc(STRATEGY_DEFAULT, pc_identifier, &pc_id_sz, &execEnvInfo)) {
			cout << "pc signature is :" << endl;
			cout << "    " << pc_identifier << endl;

			cout << endl << "execution environment:" << endl;
			cout << "    virtualization summary : " << stringByVirtSummary[execEnvInfo.virtualization] << endl;
			cout << "    cloud provider         : " << stringByCloudProvider[execEnvInfo.cloud_provider] << endl;
			cout << "    virtualization detail  : " << stringByVirtDetail[execEnvInfo.virtualization_detail] << endl;
		} else {
			cerr << "errors in identify_pc" << endl;
		}
	}

	return result;
}
