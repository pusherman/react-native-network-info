export namespace NetworkInfo {
  function getSSID(callback: (ssid: string) => void): void;
  function getBSSID(callback: (bssid: string | null) => void): void;
  function getBroadcast(callback: (ip: string | null) => void): void;
  function getIPAddress(callback: (ip: string | null) => void): void;
  function getIPV4Address(callback: (ip: string | null) => void): void;
}
