module Plaid.Schema
       ( linkSchema
       , itemManagementSchema
       , productAccessSchema
       , reportManagementSchema
       , institutionSchema
       ) where

linkSchema :: LinkSchema
linkSchema =
  { exchangeToken: "/item/public_token/exchange"
  , createToken: "/item/public_token/create"
  }

itemManagementSchema :: ItemManagement
itemManagementSchema =
  { getAccounts: "/accounts/get"
  , getItem: "/item/get"
  , updateWebhook: "/item/webhook/update"
  , invalidateToken:  "/item/access_token/invalidate"
  , removeItem: "/item/remove"
  }

productAccessSchema :: ProductAccessSchema
productAccessSchema =
  { getAuth: "/auth/get"
  , getTransactions: "/transactions/get"
  , getBalance: "/accounts/balance/get"
  , getIdentity: "/identity/get"
  , getIncome: "/income/get"
  , getAssetReport: "/asset_report/get"
  , getPdfAssetReport: "/asset_report/pdf/get"
  , refreshAssetReport: "/asset_report/refresh"
  , filterAssetReport: "/asset_report/filter"
  , getInvestmentHoldings: "/investments/holdings/get"
  , getInvestmentTransactions: "/investments/transactions/get"
  }

reportManagementSchema :: ReportManagementSchema
reportManagementSchema =
  { reportManagementCreateAssetReport: "/asset_report/create"
  , reportManagementRemoveAssetReport: "/asset_report/remove"
  , reportManagementCreateAuditCopy: "/asset_report/audit_copy/create"
  , reportManagementRemoveAuditCopy: "/asset_report/audit_copy/remove"
  }

institutionSchema :: InstitutionSchema
institutionSchema =
  { institutionGetInstitution: "/institutions/get"
  , institutionGetInstitutionById: "/institutions/get_by_id"
  , institutionSearchInstitution: "/institutions/search"
  }

categorySchema :: CategorySchema
categorySchema =
  { categoryGetCategories: "categories/get"
  }

type LinkSchema =
  { exchangeToken :: String
  , createToken :: String
  }

type ReportManagementSchema =
  { reportManagementCreateAssetReport :: String
  , reportManagementRemoveAssetReport :: String
  , reportManagementCreateAuditCopy :: String
  , reportManagementRemoveAuditCopy :: String
  }

type ProductAccessSchema =
  { getAuth :: String
  , getTransactions :: String
  , getBalance :: String
  , getIdentity :: String
  , getIncome :: String
  , getAssetReport :: String
  , refreshAssetReport :: String
  , filterAssetReport :: String
  , getPdfAssetReport :: String
  , getInvestmentHoldings :: String
  , getInvestmentTransactions :: String
  }

type ItemManagement =
  { getAccounts :: String
  , getItem :: String
  , updateWebhook :: String
  , invalidateToken :: String
  , removeItem :: String
  }

type InstitutionSchema =
  { institutionGetInstitution :: String
  , institutionGetInstitutionById :: String
  , institutionSearchInstitution :: String
  }

type CategorySchema =
  { categoryGetCategories :: String }
