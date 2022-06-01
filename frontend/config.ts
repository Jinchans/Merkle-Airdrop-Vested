// Types
type IConfig = {
  decimals: number;
  airdrop: Record<string, number>;
};

// Config from generator
const config: IConfig = {
  "decimals": 18,
  "airdrop": {
    "0xDED270233f774c902Bb77CB8A1e2960D33601B69": 723,
    "0xCdaa67F8864C90A6782Dff65D38aD368cF0f496F": 124,
    "0xcB1C0F185FFF32f43B9A292e9cbCd0Bc34e0c95C": 35

  },
};

// Export config
export default config;