#[no_mangle]
pub extern "C" fn hello_dpi(ind: u8) {
    println!("Hello DPI, {}", ind);
}
