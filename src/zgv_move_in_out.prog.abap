*&---------------------------------------------------------------------*
*& Report zgv_move_in_out
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgv_move_in_out.




****************************** BLOCK ONE ****************************************
SELECTION-SCREEN: BEGIN OF BLOCK one WITH FRAME TITLE txt1.
SELECTION-SCREEN: SKIP.
PARAMETERS:
    p_id_bp TYPE zgv_de_id.
SELECTION-SCREEN: SKIP.

SELECTION-SCREEN: BEGIN OF LINE.
SELECTION-SCREEN: PUSHBUTTON 4(20) mo_btn1 USER-COMMAND mo_btn1.
SELECTION-SCREEN: END OF LINE.

SELECTION-SCREEN: END OF BLOCK one.
SELECTION-SCREEN: SKIP 2.

****************************** BLOCK TWO ****************************************
SELECTION-SCREEN: BEGIN OF BLOCK two WITH FRAME TITLE txt2.
SELECTION-SCREEN: SKIP.
PARAMETERS:

    p_id_bp2 TYPE zgv_de_id,
    p_id_a TYPE zgv_de_id,
    p_str TYPE zgv_de_street,
    p_str_no TYPE zgv_de_street_number,
    p_city TYPE zgv_de_city,
    p_city_c TYPE zgv_de_city_code,
    p_countr TYPE zgv_de_country.

SELECTION-SCREEN: SKIP.
SELECTION-SCREEN: BEGIN OF LINE.
SELECTION-SCREEN: PUSHBUTTON 4(20) mi_btn1 USER-COMMAND mi_btn1.
SELECTION-SCREEN: END OF LINE.

SELECTION-SCREEN: END OF BLOCK two.

****************************** INITIALIZATION **************************************
INITIALIZATION.
txt1 = 'Move Out'.
txt2 = 'Move In'.

mo_btn1 = 'Confirm Move Out'.
mi_btn1 = 'Confirm Move In'.

****************************** ACTIONS **********************************************
AT SELECTION-SCREEN.
CASE sy-ucomm.

        WHEN 'MO_BTN1'.

        UPDATE ZGV_T_BP SET id_adress = '' WHERE id = p_id_bp.
        IF sy-subrc <> 0.
            MESSAGE 'Buisiness Partner with ID  ' && p_id_bp && ' is not assigned to an adress.' TYPE 'I'.
        ENDIF.
        UPDATE ZGV_T_ADRESS SET to_date = sy-datum to_time = sy-timlo WHERE id = p_id_bp.
        IF sy-subrc = 0.
            MESSAGE 'Business Partner succefuly moved out!' TYPE 'S'.
        ENDIF.


        WHEN 'MI_BTN1'.
        UPDATE ZGV_T_BP SET id_adress = p_id_a WHERE id = p_id_bp2.
        IF sy-subrc <> 0.
            MESSAGE 'Error!' TYPE 'S'.
        ENDIF.

        DATA: lv_adress TYPE ZGV_T_ADRESS.
              lv_adress = VALUE #(
              id = p_id_a
              id_business_partner = p_id_bp2
              street = p_str
              street_number = p_str_no
              city = p_city
              city_code = p_city_c
              country = p_countr
              from_date = sy-datum
              from_time = sy-timlo
               ).
        INSERT INTO ZGV_T_ADRESS VALUES lv_adress.
        IF sy-subrc = 0.
            MESSAGE 'Business Partner succefuly moved in!' TYPE 'S'.
        ELSE.
            MESSAGE 'Business Partner ID not valid.' TYPE 'I'.
        ENDIF.






ENDCASE.
