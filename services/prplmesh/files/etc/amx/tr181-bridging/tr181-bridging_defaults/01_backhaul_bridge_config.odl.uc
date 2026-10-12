%populate {
    object Bridging.Bridge.lan.Port {
{% let apindex = length( BD.Interfaces ) %}
{% for ( let Radio in BD.Radios ) : %}
        instance add("backhaul_{{Radio.Alias}}") {
            parameter Enable = true;
            parameter LowerLayers = "Device.WiFi.SSID.{{apindex + 1}}.";
            parameter IsWireless = true;
            parameter WirelessSectionName = "backhaul_{{Radio.Alias}}";
        }
{% apindex = apindex + 1 %}
{% endfor %}
    }
}

