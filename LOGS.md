# LOGS
Pointers are defined as "NAME1_NAME2_POINTER",
The keccak256 is defined as "KECCAK_POINTER:name1.name2".

Function parameters Format:
- _functionSelectors instead of funcSelectors

# ERRORS LIST
WebMethod Error IDs formatted as "MOD_ID"

### initUpdate()
- [MOD_101] _init is address(0) but _calldata is not empty
- [MOD_102] _calldata is empty but _init is not address(0)
- [MOD_103] _init address has no code
- [MOD_104] _init function reverted

### Add / Replace / Remove
- [MOD_201] Undefined selectors
- [MOD_202] Address(0) is not allowed
- [MOD_203] Undefined code
- [MOD_204] This function already exists
- [MOD_205] Undefined function
- [MOD_206] This function is immutable
- [MOD_207] Equal functions
- [MOD_208] Invalid update method

### General Errors

