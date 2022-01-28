const ohmnyomServerHost = '192.168.0.10';
const ohmnyomServerPort = 50051;

const secureStorageKeyCredential = 'cred';

const sharedPrefAutoLoginKey = 'autologin';
const sharedPrefRememberMeKey = 'rememberme';
const sharedPrefEmailKey = 'email';

const oauthProviderGoogle = "google";
const oauthProviderKakao = "kakao";

const ciPathGoogle = 'assets/ci/google.svg';
const ciPathKakao = 'assets/ci/kakao.svg';

enum SignInResult {
  fail,
  success,
}