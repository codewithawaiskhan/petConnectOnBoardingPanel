class AppCountry {
  final String code; // 2-letter uppercase ISO-3166-1 alpha-2 code (e.g., 'US', 'PK')
  final String name; // Full country name (e.g., 'United States', 'Pakistan')
  final String flag; // Emoji flag (e.g., '🇺🇸', '🇵🇰')

  const AppCountry({
    required this.code,
    required this.name,
    required this.flag,
  });

  @override
  String toString() => '$flag $name ($code)';
}

class AppCountries {
  static const List<AppCountry> countries = [
    AppCountry(code: 'AF', name: 'Afghanistan', flag: '🇦🇫'),
    AppCountry(code: 'AL', name: 'Albania', flag: '🇦🇱'),
    AppCountry(code: 'DZ', name: 'Algeria', flag: '🇩🇿'),
    AppCountry(code: 'AD', name: 'Andorra', flag: '🇦🇩'),
    AppCountry(code: 'AO', name: 'Angola', flag: '🇦🇴'),
    AppCountry(code: 'AR', name: 'Argentina', flag: '🇦🇷'),
    AppCountry(code: 'AM', name: 'Armenia', flag: '🇦🇲'),
    AppCountry(code: 'AU', name: 'Australia', flag: '🇦🇺'),
    AppCountry(code: 'AT', name: 'Austria', flag: '🇦🇹'),
    AppCountry(code: 'AZ', name: 'Azerbaijan', flag: '🇦🇿'),
    AppCountry(code: 'BH', name: 'Bahrain', flag: '🇧🇭'),
    AppCountry(code: 'BD', name: 'Bangladesh', flag: '🇧🇩'),
    AppCountry(code: 'BY', name: 'Belarus', flag: '🇧🇾'),
    AppCountry(code: 'BE', name: 'Belgium', flag: '🇧🇪'),
    AppCountry(code: 'BZ', name: 'Belize', flag: '🇧🇿'),
    AppCountry(code: 'BJ', name: 'Benin', flag: '🇧🇯'),
    AppCountry(code: 'BT', name: 'Bhutan', flag: '🇧🇹'),
    AppCountry(code: 'BO', name: 'Bolivia', flag: '🇧🇴'),
    AppCountry(code: 'BA', name: 'Bosnia and Herzegovina', flag: '🇧🇦'),
    AppCountry(code: 'BW', name: 'Botswana', flag: '🇧🇼'),
    AppCountry(code: 'BR', name: 'Brazil', flag: '🇧🇷'),
    AppCountry(code: 'BN', name: 'Brunei', flag: '🇧🇳'),
    AppCountry(code: 'BG', name: 'Bulgaria', flag: '🇧🇬'),
    AppCountry(code: 'BF', name: 'Burkina Faso', flag: '🇧🇫'),
    AppCountry(code: 'BI', name: 'Burundi', flag: '🇧🇮'),
    AppCountry(code: 'KH', name: 'Cambodia', flag: '🇰🇭'),
    AppCountry(code: 'CM', name: 'Cameroon', flag: '🇨🇲'),
    AppCountry(code: 'CA', name: 'Canada', flag: '🇨🇦'),
    AppCountry(code: 'CL', name: 'Chile', flag: '🇨🇱'),
    AppCountry(code: 'CN', name: 'China', flag: '🇨🇳'),
    AppCountry(code: 'CO', name: 'Colombia', flag: '🇨🇴'),
    AppCountry(code: 'CR', name: 'Costa Rica', flag: '🇨🇷'),
    AppCountry(code: 'HR', name: 'Croatia', flag: '🇭🇷'),
    AppCountry(code: 'CU', name: 'Cuba', flag: '🇨🇺'),
    AppCountry(code: 'CY', name: 'Cyprus', flag: '🇨🇾'),
    AppCountry(code: 'CZ', name: 'Czech Republic', flag: '🇨🇿'),
    AppCountry(code: 'DK', name: 'Denmark', flag: '🇩🇰'),
    AppCountry(code: 'DJ', name: 'Djibouti', flag: '🇩🇯'),
    AppCountry(code: 'DO', name: 'Dominican Republic', flag: '🇩🇴'),
    AppCountry(code: 'EC', name: 'Ecuador', flag: '🇪🇨'),
    AppCountry(code: 'EG', name: 'Egypt', flag: '🇪🇬'),
    AppCountry(code: 'EE', name: 'Estonia', flag: '🇪🇪'),
    AppCountry(code: 'ET', name: 'Ethiopia', flag: '🇪🇹'),
    AppCountry(code: 'FI', name: 'Finland', flag: '🇫🇮'),
    AppCountry(code: 'FR', name: 'France', flag: '🇫🇷'),
    AppCountry(code: 'GE', name: 'Georgia', flag: '🇬🇪'),
    AppCountry(code: 'DE', name: 'Germany', flag: '🇩🇪'),
    AppCountry(code: 'GH', name: 'Ghana', flag: '🇬🇭'),
    AppCountry(code: 'GR', name: 'Greece', flag: '🇬🇷'),
    AppCountry(code: 'GT', name: 'Guatemala', flag: '🇬🇹'),
    AppCountry(code: 'HK', name: 'Hong Kong', flag: '🇭🇰'),
    AppCountry(code: 'HU', name: 'Hungary', flag: '🇭🇺'),
    AppCountry(code: 'IS', name: 'Iceland', flag: '🇮🇸'),
    AppCountry(code: 'IN', name: 'India', flag: '🇮🇳'),
    AppCountry(code: 'ID', name: 'Indonesia', flag: '🇮🇩'),
    AppCountry(code: 'IR', name: 'Iran', flag: '🇮🇷'),
    AppCountry(code: 'IQ', name: 'Iraq', flag: '🇮🇶'),
    AppCountry(code: 'IE', name: 'Ireland', flag: '🇮🇪'),
    AppCountry(code: 'IL', name: 'Israel', flag: '🇮🇱'),
    AppCountry(code: 'IT', name: 'Italy', flag: '🇮🇹'),
    AppCountry(code: 'JP', name: 'Japan', flag: '🇯🇵'),
    AppCountry(code: 'JO', name: 'Jordan', flag: '🇯🇴'),
    AppCountry(code: 'KZ', name: 'Kazakhstan', flag: '🇰🇿'),
    AppCountry(code: 'KE', name: 'Kenya', flag: '🇰🇪'),
    AppCountry(code: 'KW', name: 'Kuwait', flag: '🇰🇼'),
    AppCountry(code: 'KG', name: 'Kyrgyzstan', flag: '🇰🇬'),
    AppCountry(code: 'LV', name: 'Latvia', flag: '🇱🇻'),
    AppCountry(code: 'LB', name: 'Lebanon', flag: '🇱🇧'),
    AppCountry(code: 'LY', name: 'Libya', flag: '🇱🇾'),
    AppCountry(code: 'LT', name: 'Lithuania', flag: '🇱🇹'),
    AppCountry(code: 'LU', name: 'Luxembourg', flag: '🇱🇺'),
    AppCountry(code: 'MY', name: 'Malaysia', flag: '🇲🇾'),
    AppCountry(code: 'MV', name: 'Maldives', flag: '🇲🇻'),
    AppCountry(code: 'MX', name: 'Mexico', flag: '🇲🇽'),
    AppCountry(code: 'MA', name: 'Morocco', flag: '🇲🇦'),
    AppCountry(code: 'NP', name: 'Nepal', flag: '🇳🇵'),
    AppCountry(code: 'NL', name: 'Netherlands', flag: '🇳🇱'),
    AppCountry(code: 'NZ', name: 'New Zealand', flag: '🇳🇿'),
    AppCountry(code: 'NG', name: 'Nigeria', flag: '🇳🇬'),
    AppCountry(code: 'NO', name: 'Norway', flag: '🇳🇴'),
    AppCountry(code: 'OM', name: 'Oman', flag: '🇴🇲'),
    AppCountry(code: 'PK', name: 'Pakistan', flag: '🇵🇰'),
    AppCountry(code: 'PS', name: 'Palestine', flag: '🇵🇸'),
    AppCountry(code: 'PA', name: 'Panama', flag: '🇵🇦'),
    AppCountry(code: 'PH', name: 'Philippines', flag: '🇵🇭'),
    AppCountry(code: 'PL', name: 'Poland', flag: '🇵🇱'),
    AppCountry(code: 'PT', name: 'Portugal', flag: '🇵🇹'),
    AppCountry(code: 'QA', name: 'Qatar', flag: '🇶🇦'),
    AppCountry(code: 'RO', name: 'Romania', flag: '🇷🇴'),
    AppCountry(code: 'RU', name: 'Russia', flag: '🇷🇺'),
    AppCountry(code: 'SA', name: 'Saudi Arabia', flag: '🇸🇦'),
    AppCountry(code: 'SG', name: 'Singapore', flag: '🇸🇬'),
    AppCountry(code: 'ZA', name: 'South Africa', flag: '🇿🇦'),
    AppCountry(code: 'KR', name: 'South Korea', flag: '🇰🇷'),
    AppCountry(code: 'ES', name: 'Spain', flag: '🇪🇸'),
    AppCountry(code: 'LK', name: 'Sri Lanka', flag: '🇱🇰'),
    AppCountry(code: 'SE', name: 'Sweden', flag: '🇸🇪'),
    AppCountry(code: 'CH', name: 'Switzerland', flag: '🇨🇭'),
    AppCountry(code: 'TW', name: 'Taiwan', flag: '🇹🇼'),
    AppCountry(code: 'TH', name: 'Thailand', flag: '🇹🇭'),
    AppCountry(code: 'TN', name: 'Tunisia', flag: '🇹🇳'),
    AppCountry(code: 'TR', name: 'Turkey', flag: '🇹🇷'),
    AppCountry(code: 'UA', name: 'Ukraine', flag: '🇺🇦'),
    AppCountry(code: 'AE', name: 'United Arab Emirates', flag: '🇦🇪'),
    AppCountry(code: 'GB', name: 'United Kingdom', flag: '🇬🇧'),
    AppCountry(code: 'US', name: 'United States', flag: '🇺🇸'),
    AppCountry(code: 'UY', name: 'Uruguay', flag: '🇺🇾'),
    AppCountry(code: 'UZ', name: 'Uzbekistan', flag: '🇺🇿'),
    AppCountry(code: 'VN', name: 'Vietnam', flag: '🇻🇳'),
    AppCountry(code: 'YE', name: 'Yemen', flag: '🇾🇪'),
    AppCountry(code: 'ZW', name: 'Zimbabwe', flag: '🇿🇼'),
  ];

  static AppCountry? findByCode(String? code) {
    if (code == null || code.trim().isEmpty) return null;
    final upper = code.trim().toUpperCase();
    for (final c in countries) {
      if (c.code == upper) return c;
    }
    return null;
  }

  static String getCountryName(String? code) {
    final country = findByCode(code);
    return country?.name ?? (code ?? '');
  }

  static String getFlag(String? code) {
    final country = findByCode(code);
    if (country != null) return country.flag;
    if (code == null || code.trim().length != 2) return '🏳️';
    final upper = code.trim().toUpperCase();
    final int first = upper.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int second = upper.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(first) + String.fromCharCode(second);
  }
}
