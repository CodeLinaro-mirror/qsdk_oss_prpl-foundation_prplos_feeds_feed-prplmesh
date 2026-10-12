%populate {
    object WiFi {
        object Radio {
{% for ( let Radio in BD.Radios ) : %}
            object '{{Radio.Alias}}' {
                parameter DTIMPeriod = 2;
                object IEEE80211be {
                    parameter MLReconfigurationCount = 12;
                }
            }
{% endfor; %}
        }
    }
}
