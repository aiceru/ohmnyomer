const androidPackageName = 'com.aiceru.ohmnyom';
const ohmnyomServerHost = '192.168.0.10';
const ohmnyomServerPort = 50051;

const secureStorageKeyCredential = 'cred';

const sharedPrefAutoLoginKey = 'autologin';
const sharedPrefRememberMeKey = 'rememberme';
const sharedPrefEmailKey = 'email';
const sharedPrefPetIdKey = 'petid';

const oauthProviderGoogle = "google";
const oauthProviderKakao = "kakao";
const listProviders = [oauthProviderGoogle, oauthProviderKakao];

const ciPathGoogle = 'assets/ci/google.svg';
const ciPathKakao = 'assets/ci/kakao.svg';

const unitGram = 'g';

enum SignInResult {
  fail,
  success,
}

const avatarSizeLarge = 6.2;
const avatarSizeMedium = 5.6;
const avatarSizeSmall = 5.0;

const topPanelTitleLeftPadding = 4.0;
const topPanelHeight = 10.0;

const iconSize = 8.0;
const socialLogoSize = 10.0;

const fontSizeLarge = 16.0;
const fontSizeMedium = 14.0;
const fontSizeSmall = 12.0;
