package isqo.puppetdb.client.v4.api.models.dmi;

import java.util.Map;

public class DMIFact {
    private BiosData biosData;
    private ChassisData chassisData;
    private ProductData productData;
    private String manufacturer;

    public DMIFact(Map<String, Object> map) {

        this.biosData = new BiosData((Map<String, Object>) map.get("bios"));
        this.chassisData = new ChassisData((Map<String, Object>) map.get("chassis"));
        this.productData = new ProductData((Map<String, Object>) map.get("product"));
        this.manufacturer = (String) map.get("manufacturer");
    }

    public BiosData getBiosData() {
        return biosData;
    }

    public void setBiosData(BiosData biosData) {
        this.biosData = biosData;
    }

    public ChassisData getChassisData() {
        return chassisData;
    }

    public void setChassisData(ChassisData chassisData) {
        this.chassisData = chassisData;
    }

    public ProductData getProductData() {
        return productData;
    }

    public void setProductData(ProductData productData) {
        this.productData = productData;
    }

    public String getManufacturer() {
        return manufacturer;
    }

    public void setManufacturer(String manufacturer) {
        this.manufacturer = manufacturer;
    }
}