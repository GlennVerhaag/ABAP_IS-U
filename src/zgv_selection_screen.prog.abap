*&---------------------------------------------------------------------*
*& Report zgv_selection_screen
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgv_selection_screen.

DATA business_partner TYPE REF TO zgv_c_business_partner.
DATA contract_account TYPE REF TO zgv_c_contract_account.
DATA contract type ref to ZGV_C_CONTRACT.

****************************** BLOCK ONE ****************************************
SELECTION-SCREEN: BEGIN OF BLOCK one WITH FRAME TITLE txt1.
PARAMETERS:
    p_id_bp TYPE zgv_de_id,
    p_name TYPE zgv_de_name,
    p_last TYPE zgv_de_last_name.

SELECTION-SCREEN: SKIP.

PARAMETERS:
    p_id_a TYPE zgv_de_id,
    p_str TYPE zgv_de_street,
    p_str_no TYPE zgv_de_street_number,
    p_city TYPE zgv_de_city,
    p_city_c TYPE zgv_de_city_code,
    p_countr TYPE zgv_de_country.

SELECTION-SCREEN: SKIP.

SELECTION-SCREEN: BEGIN OF LINE.
SELECTION-SCREEN: PUSHBUTTON 4(10) bp_btn1 USER-COMMAND bp_btn1,
                  PUSHBUTTON 15(10) bp_btn2 USER-COMMAND bp_btn2,
                  PUSHBUTTON 26(10) bp_btn3 USER-COMMAND bp_btn3.
SELECTION-SCREEN: END OF LINE.

SELECTION-SCREEN: END OF BLOCK one.
SELECTION-SCREEN: SKIP 2.

****************************** BLOCK TWO ****************************************
SELECTION-SCREEN: BEGIN OF BLOCK two WITH FRAME TITLE txt2.
PARAMETERS:
    p_id_ca TYPE zgv_de_id,
    p_id_bp2 TYPE zgv_de_id,
    p_card TYPE zgv_de_payment_card.
SELECTION-SCREEN: SKIP.
SELECTION-SCREEN: BEGIN OF LINE.
SELECTION-SCREEN: PUSHBUTTON 4(10) ca_btn1 USER-COMMAND ca_btn1,
                  PUSHBUTTON 15(10) ca_btn2 USER-COMMAND ca_btn2,
                  PUSHBUTTON 26(10) ca_btn3 USER-COMMAND ca_btn3.
SELECTION-SCREEN: END OF LINE.

SELECTION-SCREEN: END OF BLOCK two.
SELECTION-SCREEN: SKIP 2.

****************************** BLOCK THREE ***************************************
SELECTION-SCREEN: BEGIN OF BLOCK three WITH FRAME TITLE txt3.
PARAMETERS:
    p_id_c TYPE zgv_de_id,
    p_id_ca2 TYPE zgv_de_id,
    p_id_t TYPE zgv_de_id.
SELECTION-SCREEN: SKIP.
SELECTION-SCREEN: BEGIN OF LINE.
SELECTION-SCREEN: PUSHBUTTON 4(10) c_btn1 USER-COMMAND c_btn1,
                  PUSHBUTTON 15(10) c_btn2 USER-COMMAND c_btn2,
                  PUSHBUTTON 26(10) c_btn3 USER-COMMAND c_btn3.
SELECTION-SCREEN: END OF LINE.

SELECTION-SCREEN: END OF BLOCK three.

****************************** INITIALIZATION **************************************
INITIALIZATION.
txt1 = 'Business partner'.
txt2 = 'Contract account'.
txt3 = 'Contract'.

bp_btn1 = 'Insert'.
bp_btn2 = 'Update'.
bp_btn3 = 'Delete'.

ca_btn1 = 'Insert'.
ca_btn2 = 'Update'.
ca_btn3 = 'Delete'.

c_btn1 = 'Insert'.
c_btn2 = 'Update'.
c_btn3 = 'Delete'.

****************************** ACTIONS **********************************************
AT SELECTION-SCREEN.
    CASE sy-ucomm.
        WHEN 'BP_BTN1'.
        CREATE OBJECT business_partner.
        business_partner->set_query_parameters( id = p_id_bp name = p_name lastname = p_last id_adress = p_id_a ).
        business_partner->set_adress( id = p_id_a street = p_str street_number = p_str_no city = p_city city_code = p_city_c  country = p_countr id_business_partner = p_id_bp from_date = sy-datum from_time = sy-timlo ).
        business_partner->insert( ).
        IF sy-subrc = 0.
            MESSAGE 'Business Partner succefuly created!' TYPE 'I'.
        ENDIF.

        WHEN 'BP_BTN2'.
        CREATE OBJECT business_partner.
        business_partner->set_query_parameters( id = p_id_bp name = p_name lastname = p_last id_adress = p_id_a ).
        business_partner->update( ).
        IF sy-subrc = 0.
            MESSAGE 'Business Partner succefuly updated!' TYPE 'I'.
        ENDIF.

        WHEN 'BP_BTN3'.
        CREATE OBJECT business_partner.
        business_partner->set_query_parameters( id = p_id_bp name = p_name lastname = p_last id_adress = p_id_a ).
        business_partner->delete( ).
        IF sy-subrc = 0.
            MESSAGE 'Business Partner succefuly deleted!' TYPE 'I'.
        ENDIF.

        WHEN 'CA_BTN1'.
        CREATE OBJECT contract_account.
        contract_account->set_query_parameters( id = p_id_ca id_business_partner = p_id_bp2 payment_card = p_card ).
        contract_account->insert( ).
        IF sy-subrc = 0.
            MESSAGE 'Contract account succefuly created!' TYPE 'I'.
        ENDIF.

        WHEN 'CA_BTN2'.
        CREATE OBJECT contract_account.
        contract_account->set_query_parameters( id = p_id_ca id_business_partner = p_id_bp2 payment_card = p_card ).
        contract_account->update( ).
        IF sy-subrc = 0.
            MESSAGE 'Contract account succefuly updated!' TYPE 'I'.
        ENDIF.

        WHEN 'CA_BTN3'.
        CREATE OBJECT contract_account.
        contract_account->set_query_parameters( id = p_id_ca id_business_partner = p_id_bp2 payment_card = p_card ).
        contract_account->delete( ).
        IF sy-subrc = 0.
            MESSAGE 'Contract account succefuly deleted!' TYPE 'I'.
        ENDIF.

        WHEN 'C_BTN1'.
        CREATE OBJECT contract.
        contract->set_query_parameters( id = p_id_c id_contract_account = p_id_ca2 id_tariff = p_id_t ).
        contract->insert( ).
        IF sy-subrc = 0.
            MESSAGE 'Contract succefuly created!' TYPE 'I'.
        ENDIF.

        WHEN 'C_BTN2'.
        CREATE OBJECT contract.
        contract->set_query_parameters( id = p_id_c id_contract_account = p_id_ca2 id_tariff = p_id_t ).
        contract->update( ).
        IF sy-subrc = 0.
            MESSAGE 'Contract succefuly updated!' TYPE 'I'.
        ENDIF.

        WHEN 'C_BTN3'.
        CREATE OBJECT contract.
        contract->set_query_parameters( id = p_id_c id_contract_account = p_id_ca2 id_tariff = p_id_t ).
        contract->delete( ).
        IF sy-subrc = 0.
            MESSAGE 'Contract succefuly deleted!' TYPE 'I'.
        ENDIF.


    ENDCASE.
