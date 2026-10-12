%populate {
    object WiFi {
        object AccessPoint {
{% for ( let Itf in BD.Interfaces ) : if ( BDfn.isInterfaceWirelessAp(Itf.Name) ) : %}
{% if (Itf.OperatingFrequency != "") : %}
            object '{{Itf.Alias}}' {
                parameter MultiAPType = "FronthaulBSS";
{% if ( BDfn.isInterfaceGuest(Itf.Name) ) : %}
{% if (Itf.OperatingFrequency == "2.4GHz") : %}
                parameter CustomAlias = "vap24gguest";
{% elif (Itf.OperatingFrequency == "5GHz") : %}
                parameter CustomAlias = "vap5gguest";
{% elif (Itf.OperatingFrequency == "6GHz") : %}
                parameter CustomAlias = "vap6gguest";
{% endif %}
{% elif ( BDfn.isInterfaceLan(Itf.Name) ) : %}
{% if (Itf.OperatingFrequency == "2.4GHz") : %}
                parameter CustomAlias = "vap24ghome";
{% elif (Itf.OperatingFrequency == "5GHz") : %}
                parameter CustomAlias = "vap5ghome";
{% elif (Itf.OperatingFrequency == "6GHz") : %}
                parameter CustomAlias = "vap6ghome";
{% endif %}
{% endif %}

                object IEEE80211u {
                    parameter InterworkingEnable = 1;
                }
            }
{% endif%}
{% endif; endfor; %}
        }

{% let apindex = length( BD.Interfaces ) %}
{% for ( let Radio in BD.Radios ) : %}
        object SSID {
            instance add ({{apindex + 1}}, "backhaul_{{Radio.Alias}}") {
                parameter SSID = "backhaul_$(HWMACADDRESS)";
                parameter Enable = 0;
                parameter MLDUnit = 2;
{% RadioIndex = BDfn.getRadioIndex(Radio.OperatingFrequency) ; %}
{% if (RadioIndex >= 0) : %}
                parameter LowerLayers = "Device.WiFi.Radio.{{RadioIndex + 1}}.";
{% endif %}
            }
        }
        object AccessPoint {
            instance add ("backhaul_{{Radio.Alias}}") {
{% if (Radio.OperatingFrequency == "2.4GHz") : %}
                parameter CustomAlias = "vap24gbackhaul";
{% elif (Radio.OperatingFrequency == "5GHz") : %}
                parameter CustomAlias = "vap5gbackhaul";
{% elif (Radio.OperatingFrequency == "6GHz") : %}
                parameter CustomAlias = "vap6gbackhaul";
{% endif %}
                parameter SSIDAdvertisementEnabled = 0;
                parameter SSIDReference = "Device.WiFi.SSID.{{apindex + 1}}.";
                parameter Enable = 0;
                parameter IEEE80211kEnabled = 1;
                parameter MultiAPType = "BackhaulBSS";
                parameter BridgeInterface = "{{BD.Bridges.Lan.Name}}";
{% if ((Radio.OperatingFrequency == "5GHz") || (Radio.OperatingFrequency == "6GHz")) : %}
                parameter WDSEnable = 1;
{% endif %}
                object Security {
                    parameter RekeyingInterval = 3600;
{% if (Radio.OperatingFrequency == "6GHz") : %}
                    parameter ModesAvailable = "WPA3-Personal,WPA3-Personal-Compatibility,OWE";
                    parameter ModeEnabled = "WPA3-Personal";
                    parameter SAEPassphrase = "";
                    parameter SPPAMSDU = 0;
{% else %}
                    parameter ModesAvailable = "None,WPA2-Personal,WPA3-Personal,WPA3-Personal-Transition,WPA3-Personal-Compatibility,OWE";
                    parameter ModeEnabled = "WPA3-Personal-Transition";
{% endif %}
                    parameter KeyPassphrase = "password";
                }
                object WPS {
                    parameter ConfigMethodsEnabled = "PhysicalPushButton,VirtualPushButton,Display,VirtualDisplay,PIN";
                    parameter Configured = 1;
                    parameter Enable = 0;
                }
                object IEEE80211u {
                    parameter InterworkingEnable = 1;
                }
            }
        }
{% apindex = apindex + 1 %}
{% endfor %}
    }
}
