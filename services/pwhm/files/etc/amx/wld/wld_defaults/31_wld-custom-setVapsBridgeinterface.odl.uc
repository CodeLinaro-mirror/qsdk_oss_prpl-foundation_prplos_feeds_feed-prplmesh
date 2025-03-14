%populate {
    object WiFi {
        object AccessPoint {
{% let apindex = 0 %}
{% for ( let Itf in BD.Interfaces ) : if ( BDfn.isInterfaceWirelessAp(Itf.Name) ) : %}
{% if (BDfn.isInterfaceLan(Itf.Name)) : %}
            object '{{Itf.Alias}}' {
                parameter BridgeInterface = "{{BD.Bridges.Lan.Name}}";
            }
{% endif %}
{% endif; endfor; %}
        }
    }
}
