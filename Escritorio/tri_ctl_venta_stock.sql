create or replace trigger tri_ctl_venta_stock
  after 
  insert or delete on VENTA
  for each row
  
  declare
    v_stock producto.pro_stock%TYPE;
    v_nom_producto producto.pro_nombre%TYPE;
    e_stock_error exception;
  
  begin
    if inserting then
      SELECT PRO_STOCK  
      into v_stock
      from PRODUCTO      
      where PRO_COD = :new.VTA_PROD;
      if v_stock > 0 then
        UPDATE PRODUCTO 
        SET PRO_STOCK = v_stock - :new.VTA_CANT 
        WHERE PRO_COD = :new.VTA_PROD;
    else
      SELECT PRO_NOMBRE  
      into v_nom_producto
      from PRODUCTO      
      where PRO_COD = :new.VTA_PROD;
      raise e_stock_error;
      end if;
    end if;
    
    if deleting then
      SELECT PRO_STOCK  
      into v_stock
      from PRODUCTO      
      where PRO_COD = :old.VTA_PROD;
      
      UPDATE PRODUCTO 
      SET PRO_STOCK = v_stock + :old.VTA_CANT 
      WHERE PRO_COD = :old.VTA_PROD;
    end if;
  exception
  when e_stock_error then
    raise_application_error(-20010, 'No es posible realizar la venta del producto '|| :new.VTA_PROD ||' '||v_nom_producto||' 
    ya que no tiene stock disponible.' );
end;
