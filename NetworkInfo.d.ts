export namespace NetworkInfo {
  function getSSID(): Promise<string | null>;
  function getBSSID(): Promise<string | null>;
  function getBroadcast(): Promise<string | null>;
  function getIPAddress(): Promise<string | null>;
  function getIPV4Address(): Promise<string | null>;
  function getSubnet(): Promise<string | null>;
  function getGatewayIPAddress(): Promise<string | null>;
  function getFrequency(): Promise<number | null>;
}
