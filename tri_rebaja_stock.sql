create or replace trigger tri_rebaja_stock
  after 
  insert on VENTA
  for each row
  
  declare
    v_stock producto.pro_stock%TYPE;
  
  begin
    if inserting then
      SELECT PRO_STOCK  
      into v_stock
      from PRODUCTO      
      where PRO_COD = :new.VTA_PROD;
      
      
      UPDATE PRODUCTO 
      SET PRO_STOCK = v_stock - :new.VTA_CANT 
      WHERE PRO_COD = :new.VTA_PROD;
    end if;
    
end;
