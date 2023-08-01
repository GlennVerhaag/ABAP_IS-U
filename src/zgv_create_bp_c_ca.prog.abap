*&---------------------------------------------------------------------*
*& Report zgv_create_bp_c_ca
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgv_create_bp_c_ca.

DATA business_partner TYPE REF TO zgv_c_business_partner.
DATA business_partner_record TYPE zgv_t_bp.
DATA lv_id TYPE ZGV_DE_ID.
DATA lv_c_id TYPE ZGV_DE_ID VALUE 1.
DATA lv_ca_id TYPE ZGV_DE_ID VALUE 1.
DATA lv_tarif_id TYPE ZGV_DE_ID VALUE 1.
DATA contract_account TYPE REF TO zgv_c_contract_account.
data contract type ref to ZGV_C_CONTRACT.
DATA(o_rand_i) = cl_abap_random_int=>create( seed = cl_abap_random=>seed( ) min = 1 max = 2 ).

CREATE OBJECT business_partner.
business_partner->clear_db_table( ).

CREATE OBJECT contract_account.
contract_account->clear_db_table( ).

CREATE OBJECT contract.
contract->clear_db_table( ).

delete from ZGV_T_ADRESS.

DO 5 TIMES.
  CASE sy-index.
    WHEN 1.
        lv_id = 1.
    WHEN 2.
        lv_id = 2.
    WHEN 3.
        lv_id = 3.
    WHEN 4.
        lv_id = 4.
    WHEN 5.
        lv_id = 5.
  ENDCASE.
  business_partner->set_query_parameters( id = lv_id name = 'Test' lastname =  'User' && lv_id id_adress = lv_id ).
  business_partner->insert( ).
  business_partner->set_adress( id = lv_id street = 'Wilhelmstraße' street_number = '76' city = 'Aachen' city_code = '52070' country = 'Germany' id_business_partner = lv_id from_date = sy-datum from_time = sy-timlo ).

  DO o_rand_i->get_next( ) times.
    contract_account->set_query_parameters( id_business_partner = lv_id id = lv_ca_id payment_card = '999' ).
    contract_account->insert( ).

    DO o_rand_i->get_next( ) times.

        contract->set_query_parameters( id_contract_account = lv_ca_id id_tariff = lv_tarif_id id = lv_c_id ).
        contract->insert( ).
        lv_c_id = lv_c_id + 1.
    enddo.
    lv_ca_id = lv_ca_id + 1.

  enddo.

ENDDO.

business_partner->write_all_business_partners( ).
contract_account->write_all_contract_accounts( ).
contract->write_all_contracts( ).
