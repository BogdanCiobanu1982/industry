{
    "$schema": "<relative path to createFormUI.schema.json>",
    "view": {
        "kind": "Form",
        "properties": {
            "title": "Power Platform Landing Zones",
            "steps": [
                {
                    "name": "powerp",
                    "label": "Deployment Setup",
                    "subLabel": {},
                    "bladeTitle": "powerp",
                    "elements": [
                        {
                            "name": "infoBox1",
                            "type": "Microsoft.Common.InfoBox",
                            "visible": true,
                            "options": {
                                "icon": "Info",
                                "text": "Power Platform Landing Zones will deploy and configure the foundation for your Power Platform tenant including all best practices and recommendations from Microsoft, and create the initial landing zones for citizen- and professional developers. The deployment requires that the user is a Global Admin or Power Platform Admin in the Azure Active Directory.",
                                "uri": "https://aka.ms/NorthStarPowerPlatform"
                            }
                        },
                        {
                            "name": "spn",
                            "type": "Microsoft.Common.Section",
                            "label": "Existing User Managed Identity Configuration",
                            "elements": [],
                            "visible": true
                        },
                        {
                            "name": "SpnBox",
                            "type": "Microsoft.Common.TextBlock",
                            "visible": true,
                            "options": {
                                "text": "The setup requires an existing User Assigned Identity that has been granted RBAC to the Power Platform to complete the deployment.",
                                "link": {
                                    "label": "Learn more",
                                    "uri": "https://docs.microsoft.com/power-platform/admin/powerplatform-api-create-service-principal"
                                }
                            }
                        },
                        {
                            "name": "ppIdentity",
                            "type": "Microsoft.Solutions.ResourceSelector",
                            "label": "Select an existing User Assigned Identity with permissions to the Power Platform APIs",
                            "resourceType": "Microsoft.ManagedIdentity/userAssignedIdentities",
                            "options": {
                                "filter": {
                                    "subscription": "all",
                                    "location": "all"
                                }
                            }
                        },
                        {
                            "name": "sub",
                            "type": "Microsoft.Common.Section",
                            "label": "Azure subscription",
                            "elements": [],
                            "visible": true
                        },
                        {
                            "name": "azureBox",
                            "type": "Microsoft.Common.TextBlock",
                            "visible": true,
                            "options": {
                                "text": "The setup requires an existing Azure subscription to provision the required infrastructure and components, both in Azure and in Power Platform. Select a subscription and a region where the deployment should be placed, and also specify if you want to use this subscription for all Azure services and required configuration.",
                                "link": {
                                    "label": "Learn more",
                                    "uri": "https://docs.microsoft.com/azure/azure-resource-manager/templates/deploy-to-subscription?tabs=azure-cli"
                                }
                            }
                        },
                        {
                            "name": "subscriptionApi",
                            "type": "Microsoft.Solutions.ArmApiControl",
                            "request": {
                                "method": "GET",
                                "path": "subscriptions?api-version=2020-01-01"
                            }
                        },
                        {
                            "name": "subscriptionId",
                            "label": "Subscription",
                            "type": "Microsoft.Common.DropDown",
                            "visible": true,
                            "defaultValue": "",
                            "toolTip": "Select the Subscription for the deployment.",
                            "multiselect": false,
                            "selectAll": false,
                            "filter": true,
                            "filterPlaceholder": "Filter items ...",
                            "multiLine": true,
                            "constraints": {
                                "allowedValues": "[map(steps('powerp').subscriptionApi.value, (item) => parse(concat('{\"label\":\"', item.displayName, '\",\"value\":\"', item.id, '\",\"description\":\"', 'ID: ', item.subscriptionId, '\"}')))]",
                                "required": true
                            }
                        },
                        {
                            "name": "locationsApi",
                            "type": "Microsoft.Solutions.ArmApiControl",
                            "request": {
                                "method": "GET",
                                "path": "locations?api-version=2019-11-01"
                            }
                        },
                        {
                            "name": "locationName",
                            "label": "Location",
                            "type": "Microsoft.Common.DropDown",
                            "visible": true,
                            "defaultValue": "",
                            "toolTip": "Select the Location for the deployment.",
                            "multiselect": false,
                            "selectAll": false,
                            "filter": true,
                            "filterPlaceholder": "Filter items ...",
                            "multiLine": true,
                            "constraints": {
                                "allowedValues": "[map(steps('powerp').locationsApi.value,(item) => parse(concat('{\"label\":\"',item.displayName,'\",\"value\":\"',item.name,'\"}')))]",
                                "required": true
                            }
                        },
                        {
                            "name": "subOption",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Use this subscription for all Azure services and configuration",
                            "defaultValue": "Yes",
                            "multiSelect": true,
                            "toolTip": "If 'Yes' is selected, the setup will configure this setting.",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            },
                            "visible": true
                        }
                    ]
                },
                {
                    "name": "gov",
                    "label": "Tenant Setup",
                    "elements": [
                        {
                            "name": "govInfo",
                            "type": "Microsoft.Common.InfoBox",
                            "visible": true,
                            "options": {
                                "icon": "Info",
                                "text": "Configure tenant security settings and Data-loss prevention policies for Power Platform to meet your overall security requirements. These settings will apply to all existing and new environments in your tenant, and additional restrictions can be configured later in the deployment experience.",
                                "uri": "https://aka.ms/NorthStarPowerPlatform"
                            }
                        },
                        {
                            "name": "dlpTenant",
                            "type": "Microsoft.Common.Section",
                            "label": "Tenant Data-loss prevention policy",
                            "elements": [],
                            "visible": true
                        },
                        {
                            "name": "dlpTenantText",
                            "type": "Microsoft.Common.TextBlock",
                            "visible": true,
                            "options": {
                                "text": "Configure overall Data-loss prevention policy for the tenant. This policy will by default apply to all existing and new environments. Additional policies can be configured in the 'Landing Zones' tab.",
                                "link": {
                                    "label": "Learn more",
                                    "uri": "https://docs.microsoft.com/power-platform/admin/wp-data-loss-prevention"
                                }
                            }
                        },
                        {
                            "name": "ppTenantDlp",
                            "type": "Microsoft.Common.DropDown",
                            "multiSelect": false,
                            "multiLine": true,
                            "label": "Assign recommended Data-loss prevention policies to the tenant by selecting the preferred starting baseline.",
                            "defaultValue": "None",
                            "toolTip": "By select a tenant DLP policy, all existing and new Environments will be governed regarding what connectors can be used, and used together.",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "High",
                                        "description": "A highly restrictive tenant DLP policy that only allows certain Microsoft connectors in the business group. All other connectors are categorized as non-business.",
                                        "value": "high"
                                    },
                                    {
                                        "label": "Medium",
                                        "description": "A medium restrictive tenant DLP policy that allows common Microsoft connectors in the business group. All other connectors are categorized as non-business.",
                                        "value": "medium"
                                    },
                                    {
                                        "label": "Low",
                                        "description": "A low restrictive tenant DLP policy that allows most Microsoft connectors in the business group. All other connectors are categorized as non-business.",
                                        "value": "low"
                                    },
                                    {
                                        "label": "None",
                                        "description": "Do not assign tenant DLP policy.",
                                        "value": "none"
                                    }
                                ],
                                "required": true
                            },
                            "visible": true
                        },
                        {
                            "name": "tenantIsolationSetting",
                            "type": "Microsoft.Common.Section",
                            "label": "Tenant isolation (preview)",
                            "elements": [],
                            "visible": true
                        },
                        {
                            "name": "tenantIsolationText",
                            "type": "Microsoft.Common.TextBlock",
                            "visible": true,
                            "options": {
                                "text": "Configure tenant isolation to block external tenants from establishing connections into your tenant (inbound isolation) as well as block your tenant from establishing connections to external tenants (outbound isolation).",
                                "link": {
                                    "label": "Learn more",
                                    "uri": "https://docs.microsoft.com/power-platform/admin/cross-tenant-restrictions"
                                }
                            }
                        },
                        {
                            "name": "ppTenantIsolationSetting",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Enable tenant isolation",
                            "defaultValue": "Do not enable tenant isolation",
                            "toolTip": "Select the preferred tenant isolation method by selecting either inbound, outbound, or both.",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Block inbound",
                                        "value": "inbound"
                                    },
                                    {
                                        "label": "Block outbound",
                                        "value": "outbound"
                                    },
                                    {
                                        "label": "Block both inbound and outbound",
                                        "value": "both"
                                    },
                                    {
                                        "label": "Do not enable tenant isolation",
                                        "value": "none"
                                    }
                                ],
                                "required": true
                            },
                            "visible": true
                        },
                        {
                            "name": "ppTenantIsolationDomains",
                            "type": "Microsoft.Common.TextBox",
                            "label": "Explicit allow list (enter Tenant Domain, ID, or * for all tenants)",
                            "placeholder": "",
                            "defaultValue": "",
                            "toolTip": "Use only allowed characters",
                            "constraints": {
                                "required": false
                            },
                            "visible": "[not(equals(steps('gov').ppTenantIsolationSetting, 'none'))]"
                        },
                        {
                            "name": "tenantGuestsAndSharing",
                            "type": "Microsoft.Common.Section",
                            "label": "Tenant Guest user and sharing settings",
                            "elements": [],
                            "visible": true
                        },
                        {
                            "name": "tenantText",
                            "type": "Microsoft.Common.TextBlock",
                            "visible": true,
                            "options": {
                                "text": "Configure tenant guest and sharing options.",
                                "link": {
                                    "label": "Learn more",
                                    "uri": "https://docs.microsoft.com/powerapps/maker/model-driven-apps/share-model-driven-app#app-sharing-privilege-and-licensing-requirements"
                                }
                            }
                        },
                        {
                            "name": "ppGuestMakerSetting",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Prevent Azure AD guests accounts to make Power Apps",
                            "defaultValue": "Yes",
                            "multiSelect": true,
                            "toolTip": "If 'Yes' is selected, the setup will configure this setting.",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            },
                            "visible": true
                        },
                        {
                            "name": "ppAppSharingSetting",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Restrict sharing of PowerApps with the entire organization",
                            "defaultValue": "Yes",
                            "multiSelect": true,
                            "toolTip": "If 'Yes' is selected, the setup will configure this setting.",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            },
                            "visible": true
                        },
                        {
                            "name": "envBox",
                            "type": "Microsoft.Common.InfoBox",
                            "visible": true,
                            "options": {
                                "text": "It is highly recommended to have dedicated Admin Environments in Power Platform to manage and administer the platform as you scale. When creating dedicated Admin Environments, you can optionally deploy the 'Center of Excellence Starter-Kit' post deployement which provides additional capabilities to scale, manage, and operate your Power Platform tenant. The setup creates dedicated Admin Environments for Development, Test, and Production in order to support maintenance, testing, development, and validation before deploying to production.",
                                "link": {
                                    "label": "Learn more about Center of Excellence Starter-kit",
                                    "uri": "https://docs.microsoft.com/power-platform/guidance/coe/starter-kit"
                                }
                            }
                        },
                        {
                            "name": "tenantEnv",
                            "type": "Microsoft.Common.Section",
                            "label": "Tenant Environment settings",
                            "elements": [],
                            "visible": true
                        },
                        {
                            "name": "tenantEnvText",
                            "type": "Microsoft.Common.TextBlock",
                            "visible": true,
                            "options": {
                                "text": "Configure the overall Environment settings for the tenant. These settings will allow you to control Environment creation process, and capacity management.",
                                "link": {
                                    "label": "Learn more",
                                    "uri": "https://docs.microsoft.com/power-platform/admin/environments-overview"
                                }
                            }
                        },
                        {
                            "name": "ppEnvCreationSetting",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Restrict production and sandbox Environment creation to specific Admins",
                            "defaultValue": "Yes (recommended)",
                            "multiSelect": true,
                            "toolTip": "If 'Yes' is selected, the setup will configure this setting.",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            },
                            "visible": true
                        },
                        {
                            "name": "ppTrialEnvCreationSetting",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Restrict trial Environment creation to specific Admins",
                            "defaultValue": "Yes (recommended)",
                            "multiSelect": true,
                            "toolTip": "If 'Yes' is selected, the setup will configure this setting",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            },
                            "visible": true
                        },
                        {
                            "name": "ppEnvCapacitySetting",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Restrict capacity allocation to specific Admins",
                            "defaultValue": "Yes (recommended)",
                            "multiSelect": true,
                            "toolTip": "If 'Yes' is selected, the setup will configure this option.",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            },
                            "visible": true
                        },
                        {
                            "name": "adminEnv",
                            "type": "Microsoft.Common.Section",
                            "label": "Admin Environment configuration",
                            "elements": [],
                            "visible": true
                        },
                        {
                            "name": "adminEnvText",
                            "type": "Microsoft.Common.TextBlock",
                            "visible": true,
                            "options": {
                                "text": "Create new dedicated Admin Environments that should be used to operate and manage the overall Power Platform tenant, such as Environment creation, DLP management, Identity and Access, and analytics.",
                                "link": {
                                    "label": "Learn more",
                                    "uri": "https://aka.ms/NorthStarPowerPlatform"
                                }
                            }
                        },
                        {
                            "name": "ppAdminEnvEnablement",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Create dedicated Admin environments",
                            "defaultValue": "Yes (recommended)",
                            "multiSelect": true,
                            "toolTip": "If 'Yes' is selected, the setup will configure this option.",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            },
                            "visible": true
                        },
                        {
                            "name": "ppAdminEnvNaming",
                            "type": "Microsoft.Common.TextBox",
                            "label": "Provide naming convention for the Admin environments",
                            "placeholder": "",
                            "defaultValue": "",
                            "toolTip": "Use only allowed characters",
                            "constraints": {
                                "required": true,
                                "regex": "^[a-z0-9A-Z]{1,30}$",
                                "validationMessage": "Only alphanumeric characters are allowed, and the value must be 1-30 characters long."
                            },
                            "visible": "[equals(steps('environments').ppAdminEnvEnablement, 'yes')]"
                        },
                        {
                            "name": "ppAdminRegion",
                            "type": "Microsoft.Common.DropDown",
                            "label": "Select region for the new Admin Environments",
                            "placeholder": "",
                            "defaultValue": "",
                            "toolTip": "",
                            "visible": "[equals(steps('environments').ppAdminEnvEnablement, 'yes')]",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Europe",
                                        "value": "europe"
                                    },
                                    {
                                        "label": "United States",
                                        "value": "unitedstates"
                                    },
                                    {
                                        "label": "United Arab Emirates",
                                        "value": "unitedarabemirates"
                                    },
                                    {
                                        "label": "Asia",
                                        "value": "asia"
                                    },
                                    {
                                        "label": "India",
                                        "value": "india"
                                    },
                                    {
                                        "label": "Japan",
                                        "value": "japan"
                                    },
                                    {
                                        "label": "France",
                                        "value": "france"
                                    },
                                    {
                                        "label": "Germany",
                                        "value": "germany"
                                    },
                                    {
                                        "label": "Australia",
                                        "value": "australia"
                                    },
                                    {
                                        "label": "Canada",
                                        "value": "canada"
                                    },
                                    {
                                        "label": "South America",
                                        "value": "southamerica"
                                    },
                                    {
                                        "label": "Norway",
                                        "value": "norway"
                                    }
                                ],
                                "required": true
                            }
                        },
						{
                            "name": "ppAdminBilling",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Create Billing Policy and Use Azure Subscription for pay-as-you-go for the environments",
                            "defaultValue": "Yes (recommended)",
                            "toolTip": "If 'Yes' is selected, the setup will configure this option.",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            },
                            "visible": "[equals(steps('environments').ppAdminEnvEnablement, 'yes')]"
                        },
                        {
                            "name": "ppAdminDlp",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Assign recommended Data-loss prevention policies to the Admin Environments",
                            "defaultValue": "Yes (recommended)",
                            "multiSelect": true,
                            "toolTip": "If 'Yes' is selected, the setup will enable this",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            },
                            "visible": "[equals(steps('environments').ppAdminEnvEnablement, 'yes')]"
                        },
						{
                            "name": "ppAdminManagedText",
                            "type": "Microsoft.Common.TextBlock",
                            "visible": "[equals(steps('environments').ppAdminEnvEnablement, 'yes')]",
                            "options": {
                                "text": "Enabling Managed Environment in this step will opt-in to weekly digest, and allow you to continue the configuration in Power Platform Admin Center for sharing restrictions, DLPs and more post deployment.",
                                "link": {
                                    "label": "Learn more",
                                    "uri": "https://docs.microsoft.com/power-platform/admin/managed-environment-overview"
                                }
                            }
                        },
                        {
                            "name": "ppAdminManagedEnv",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Enable Managed Environments (Preview) for the Admin Environments",
                            "defaultValue": "Yes (recommended)",
                            "toolTip": "Managed Environments is a suite of capabilities that allows admins to manage Power Platform at scale with more control, less effort, and more insights",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ],
                                "required": true
                            },
                            "visible": "[equals(steps('environments').ppAdminEnvEnablement, 'yes')]"
                        }
                    ]
                },                                
                {
                    "name": "mgmt",
                    "label": "Management and Monitoring",
                    "elements": [
                        {
                            "name": "infoBox1",
                            "type": "Microsoft.Common.InfoBox",
                            "visible": true,
                            "options": {
                                "icon": "Info",
                                "text": "Configure management and monitoring services for your Power Platform tenant, using recommended Azure services.",
                                "uri": "https://aka.ms/NorthStarPowerPlatform"
                            }
                        },
                        {
                            "name": "logging",
                            "type": "Microsoft.Common.Section",
                            "label": "Tenant observability, security, and logging",
                            "elements": [],
                            "visible": true
                        },
                        {
                            "name": "tenantMonitoringText",
                            "type": "Microsoft.Common.TextBlock",
                            "visible": true,
                            "options": {
                                "text": "Configure critical security and observability options for the Power Platform tenant. These options requires an Azure subscription and Azure services.",
                                "link": {
                                    "label": "Learn more",
                                    "uri": "https://aka.ms/NorthStarPowerPlatform"
                                }
                            }
                        },
                        {
                            "name": "ppEnableAzureMonitor",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Enable recommended observability and security integration using Azure services",
                            "defaultValue": "Yes (recommended)",
                            "toolTip": "",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            },
                            "visible": true
                        },
                        {
                            "name": "ppRetentionInDays",
                            "type": "Microsoft.Common.Slider",
                            "min": 30,
                            "max": 730,
                            "label": "Log Analytics Data Retention (days)",
                            "subLabel": "Days",
                            "defaultValue": 30,
                            "showStepMarkers": false,
                            "toolTip": "Select retention days for Azure logs. Default is 30 days.",
                            "constraints": {
                                "required": false
                            },
                            "visible": "[equals(steps('mgmt').ppEnableAzureMonitor, 'yes')]"
                        },
                        {
                            "name": "azMonSection",
                            "type": "Microsoft.Common.Section",
                            "label": "Azure Monitor setup",
                            "elements": [],
                            "visible": "[equals(steps('mgmt').ppEnableAzureMonitor, 'yes')]"
                        },
                        {
                            "name": "azMonitoringText",
                            "type": "Microsoft.Common.TextBlock",
                            "visible": "[equals(steps('mgmt').ppEnableAzureMonitor, 'yes')]",
                            "options": {
                                "text": "Configure Azure Monitor solutions that will be integrated to enhance the security posture of your Power Platform tenant.",
                                "link": {
                                    "label": "Learn more",
                                    "uri": "https://aka.ms/NorthStarPowerPlatform"
                                }
                            }
                        },
                        {
                            "name": "ppEnable365Compliance",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Enable auditing and integration with M365 Security & Compliance Center",
                            "defaultValue": "Yes (recommended)",
                            "visible": "[equals(steps('mgmt').ppEnableAzureMonitor, 'yes')]",
                            "toolTip": "If 'Yes' is selected, the setup will configure this option.",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            }
                        },
                        {
                            "name": "ppEnableAadLogs",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Enable Monitoring of Azure AD logs",
                            "defaultValue": "Yes (recommended)",
                            "toolTip": "",
                            "constraints": {
                                "required": false,
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            },
                            "visible": "[equals(steps('mgmt').ppEnableAzureMonitor, 'yes')]"
                        },
                        {
                            "name": "ppEnableAzureSecurity",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Enable integration with Microsoft Sentinel",
                            "defaultValue": "Yes (recommended)",
                            "visible": "[equals(steps('mgmt').ppEnableAzureMonitor, 'yes')]",
                            "toolTip": "",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            }
                        },
                        {
                            "name": "ppEnableD365Connector",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Enable Sentinel Data Connector for Dynamics 365",
                            "defaultValue": "Yes (recommended)",
                            "visible": "[and(equals(steps('mgmt').ppEnableAzureMonitor, 'yes'), equals(steps('mgmt').ppEnableAzureSecurity, 'yes'))]",
                            "toolTip": "",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            }
                        },
                        {
                            "name": "ppEnableAppInsights",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Enable integration with Azure Application Insights",
                            "defaultValue": "Yes (recommended)",
                            "visible": "[equals(steps('mgmt').ppEnableAzureMonitor, 'yes')]",
                            "toolTip": "",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            }
                        },
                        {
                            "name": "analytics",
                            "type": "Microsoft.Common.Section",
                            "label": "Tenant analytics and usage",
                            "elements": [],
                            "visible": true
                        },
                        {
                            "name": "tenantAnalyticsText",
                            "type": "Microsoft.Common.TextBlock",
                            "visible": true,
                            "options": {
                                "text": "Configure tenant level analytics to track all-up usage and adoption within the organization across all Environments for Power Apps and Power Automate. For long-term retention, extensibility and richer analysis, you can create a Data Lake Sorage V2 into an Azure subscription and configure Data Export post deployment.",
                                "link": {
                                    "label": "Learn more",
                                    "uri": "https://aka.ms/NorthStarPowerPlatform"
                                }
                            }
                        },
                        {
                            "name": "ppEnableTenantAnalytics",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Enable Tenant level analytics for Power Platform",
                            "defaultValue": "Yes (recommended)",
                            "toolTip": "",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            },
                            "visible": true
                        },
                        {
                            "name": "ppEnableDataLake",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Enable Data Lake Storage V2 to store captured data for operational and exploratory analytics",
                            "defaultValue": "Yes (recommended)",
                            "toolTip": "",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            },
                            "visible": "[equals(steps('mgmt').ppEnableTenantAnalytics, 'yes')]"
                        }
                    ]
                },
                {
                    "name": "landingZones",
                    "label": "Landing Zones",
                    "elements": [
                        {
                            "name": "EnvBox",
                            "type": "Microsoft.Common.InfoBox",
                            "visible": true,
                            "options": {
                                "text": "Prepare and create Landing Zones (Environments for business apps, industry solutions, and professional apps) in Power Platform optimized for citizen developers, professional developers, and industry solutions. When creating these environments, the setup will instantiate dedicated Environments for Development, Test, and Production in order to support maintenance, testing, development, and validation before deploying to production. Lastly, recommended Data-loss prevention policies are provided to further govern the various scenarios.",
                                "link": {
                                    "label": "Learn more",
                                    "uri": "https://www.microsoft.com"
                                }
                            }
                        },
                        {
                            "name": "default",
                            "type": "Microsoft.Common.Section",
                            "label": "Default environment",
                            "elements": [],
                            "visible": true
                        },
                        {
                            "name": "defaultText",
                            "type": "Microsoft.Common.TextBlock",
                            "visible": true,
                            "options": {
                                "text": "The Default Environment is available for all users with a license. It is recommended to rename this Environment to clarify the intent of it, such as 'Personal Productivity', and add further restrictions using Data-lose prevention policies scoped to the Default Environment",
                                "link": {
                                    "label": "Learn more",
                                    "uri": "https://www.microsoft.com"
                                }
                            }
                        },
                        {
                            "name": "ppDefaultRename",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Rename the default environment",
                            "defaultValue": "Yes (recommended)",
                            "multiSelect": true,
                            "toolTip": "If 'Yes' is selected, the setup will rename the environment",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            },
                            "visible": true
                        },
                        {
                            "name": "ppDefaultRenameText",
                            "type": "Microsoft.Common.TextBox",
                            "label": "Provide a new name for the default environment",
                            "placeholder": "Personal",
                            "defaultValue": "Personal",
                            "toolTip": "Use only allowed characters",
                            "constraints": {
                                "required": true,
                                "regex": "^[a-z0-9A-Z]{1,30}$",
                                "validationMessage": "Only alphanumeric characters are allowed, and the value must be 1-30 characters long."
                            },
                            "visible": "[equals(steps('landingZones').ppDefaultRename, 'yes')]"
                        },
                        {
                            "name": "ppDefaultDlp",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Assign recommended Data-loss prevention policies to the Default Environment",
                            "defaultValue": "Yes (recommended)",
                            "multiSelect": true,
                            "toolTip": "If 'Yes' is selected, the setup will enable this",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            },
                            "visible": "[equals(steps('landingZones').ppDefaultRename, 'yes')]"
                        },
						{
                            "name": "ppDefaultManagedText",
                            "type": "Microsoft.Common.TextBlock",
                            "visible": "[equals(steps('landingZones').ppDefaultRename, 'yes')]",
                            "options": {
                                "text": "Enabling Managed Environment in this step will opt-in to weekly digest, and allow you to continue the configuration in Power Platform Admin Center for sharing restrictions, DLPs and more post deployment.",
                                "link": {
                                    "label": "Learn more",
                                    "uri": "https://docs.microsoft.com/power-platform/admin/managed-environment-overview"
                                }
                            }
                        },
                        {
                            "name": "ppDefaultManagedEnv",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Enable Managed Environments (Preview) for the Default Environment",
                            "defaultValue": "Yes (recommended)",
                            "toolTip": "Managed Environments is a suite of capabilities that allows admins to manage Power Platform at scale with more control, less effort, and more insights",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ],
                                "required": true
                            },
                            "visible": "[equals(steps('landingZones').ppDefaultRename, 'yes')]"
                        },
                        {
                            "name": "ppDefaultManagedSharing",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Exclude sharing with security groups",
                            "defaultValue": "Yes (recommended)",
                            "toolTip": "Help reduce risk by limiting how widely canvas apps can be shared.",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ],
                                "required": true
                            },
                            "visible": "[and(equals(steps('landingZones').ppDefaultRename, 'yes'), equals(steps('landingZones').ppDefaultManagedEnv, 'yes'))]"
                        },
                        {
                            "name": "citizenSection",
                            "type": "Microsoft.Common.Section",
                            "label": "Landing Zones for citizen developers",
                            "elements": [],
                            "visible": true
                        },
                        {
                            "name": "citizenText",
                            "type": "Microsoft.Common.TextBlock",
                            "visible": true,
                            "options": {
                                "text": "The Landing Zones for citizen developers will be optimized for no code/low code scenarios, and provide them with the required agility and simplicity to rapidly build modern business applications. You can grant business units or indivuduals access to the Environments post creation.",
                                "link": {
                                    "label": "Learn more",
                                    "uri": "https://www.microsoft.com"
                                }
                            }
                        },
                        {
                            "name": "ppCitizen",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Create Environments for citizen developer scenarios",
                            "defaultValue": "Yes",
                            "multiSelect": true,
                            "toolTip": "If 'Yes' is selected, the setup will create new environments for citizen developer scenarios",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "Yes, and let me configure each Environment",
                                        "value": "custom"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            },
                            "visible": true
                        },
                        {
                            "name": "callGraph",
                            "type": "Microsoft.Solutions.GraphApiControl",
                            "request": {
                                "method": "GET",
                                "path": "/beta/groups?&select=displayName,id",
                                "transforms": {
                                    "list": "value|[*].{label:displayName, value:id}"
                                }
                            }
                        },
                        {
                            "name": "ppCitizenConfiguration",
                            "type": "Microsoft.Common.EditableGrid",
                            "ariaLabel": "Create and Configure Citizen Environment",
                            "label": "Citizen Environment configuration",
                            "visible": "[equals(steps('landingZones').ppCitizen, 'custom')]",
                            "constraints": {
                                "width": "Full",
                                "rows": {
                                    "count": {
                                        "min": 1,
                                        "max": 10
                                    }
                                },
                                "columns": [
                                    {
                                        "id": "ppEnvName",
                                        "header": "Environment Name",
                                        "width": "1fr",
                                        "element": {
                                            "type": "Microsoft.Common.TextBox",
                                            "placeholder": "",
                                            "constraints": {
                                                "required": true,
                                                "validations": [
                                                    {
                                                        "regex": "^[a-z0-9A-Z]{1,30}$",
                                                        "message": "Only alphanumeric characters are allowed, and the value must be 1-30 characters long."
                                                    }
                                                ]
                                            }
                                        }
                                    },
                                    {
                                        "id": "ppEnvDescription",
                                        "header": "Description",
                                        "width": "1fr",
                                        "element": {
                                            "type": "Microsoft.Common.TextBox",
                                            "placeholder": "",
                                            "constraints": {
                                                "required": true,
                                                "validations": [
                                                    {
                                                        "regex": "^[a-z0-9A-Z]{1,30}$",
                                                        "message": "Only alphanumeric characters are allowed, and the value must be 1-30 characters long."
                                                    }
                                                ]
                                            }
                                        }
                                    },
                                    {
                                        "id": "ppRegion",
                                        "header": "Region",
                                        "width": "1fr",
                                        "element": {
                                            "name": "ppRegionDropDown",
                                            "type": "Microsoft.Common.DropDown",
                                            "filter": true,
                                            "placeholder": "Select a region...",
                                            "constraints": {
                                                "allowedValues": [
                                                    {
                                                        "label": "Europe",
                                                        "value": "europe"
                                                    },
                                                    {
                                                        "label": "United States",
                                                        "value": "unitedstates"
                                                    },
                                                    {
                                                        "label": "United Arab Emirates",
                                                        "value": "unitedarabemirates"
                                                    },
                                                    {
                                                        "label": "Asia",
                                                        "value": "asia"
                                                    },
                                                    {
                                                        "label": "India",
                                                        "value": "india"
                                                    },
                                                    {
                                                        "label": "Japan",
                                                        "value": "japan"
                                                    },
                                                    {
                                                        "label": "France",
                                                        "value": "france"
                                                    },
                                                    {
                                                        "label": "Germany",
                                                        "value": "germany"
                                                    },
                                                    {
                                                        "label": "Australia",
                                                        "value": "australia"
                                                    },
                                                    {
                                                        "label": "Canada",
                                                        "value": "canada"
                                                    },
                                                    {
                                                        "label": "South America",
                                                        "value": "southamerica"
                                                    },
                                                    {
                                                        "label": "Norway",
                                                        "value": "norway"
                                                    }
                                                ],
                                                "required": true
                                            }
                                        }
                                    },
                                    {
                                        "id": "ppLanguage",
                                        "header": "Language",
                                        "width": "1fr",
                                        "element": {
                                            "name": "ppLanguageDropDown",
                                            "type": "Microsoft.Common.DropDown",
                                            "placeholder": "Select a language...",
                                            "filter": true,
                                            "constraints": {
                                                "allowedValues": [
                                                    {
                                                        "label": "Arabic",
                                                        "value": "1025"
                                                    },
                                                    {
                                                        "label": "Bulgarian",
                                                        "value": "1026"
                                                    },
                                                    {
                                                        "label": "Catalan",
                                                        "value": "1027"
                                                    },
                                                    {
                                                        "label": "Chinese (Taiwan)",
                                                        "value": "1028"
                                                    },
                                                    {
                                                        "label": "Czech",
                                                        "value": "1029"
                                                    },
                                                    {
                                                        "label": "Danish",
                                                        "value": "1030"
                                                    },
                                                    {
                                                        "label": "German",
                                                        "value": "1031"
                                                    },
                                                    {
                                                        "label": "Greek",
                                                        "value": "1032"
                                                    },
                                                    {
                                                        "label": "English (United States)",
                                                        "value": "1033"
                                                    },
                                                    {
                                                        "label": "Finnish",
                                                        "value": "1035"
                                                    },
                                                    {
                                                        "label": "French",
                                                        "value": "1036"
                                                    },
                                                    {
                                                        "label": "Hebrew",
                                                        "value": "1037"
                                                    },
                                                    {
                                                        "label": "Hungarian",
                                                        "value": "1038"
                                                    },
                                                    {
                                                        "label": "Italian",
                                                        "value": "1040"
                                                    },
                                                    {
                                                        "label": "Japanese",
                                                        "value": "1041"
                                                    },
                                                    {
                                                        "label": "Korean",
                                                        "value": "1042"
                                                    },
                                                    {
                                                        "label": "Dutch",
                                                        "value": "1043"
                                                    },
                                                    {
                                                        "label": "Norwegian",
                                                        "value": "1044"
                                                    },
                                                    {
                                                        "label": "Polish",
                                                        "value": "1045"
                                                    },
                                                    {
                                                        "label": "Brazilian",
                                                        "value": "1046"
                                                    },
                                                    {
                                                        "label": "Romanian",
                                                        "value": "1048"
                                                    },
                                                    {
                                                        "label": "Russian",
                                                        "value": "1049"
                                                    },
                                                    {
                                                        "label": "Croatian",
                                                        "value": "1050"
                                                    },
                                                    {
                                                        "label": "Slovak",
                                                        "value": "1051"
                                                    },
                                                    {
                                                        "label": "Swedish",
                                                        "value": "1053"
                                                    },
                                                    {
                                                        "label": "Thai",
                                                        "value": "1054"
                                                    },
                                                    {
                                                        "label": "Turkish",
                                                        "value": "1055"
                                                    },
                                                    {
                                                        "label": "Indonesian",
                                                        "value": "1057"
                                                    },
                                                    {
                                                        "label": "Ukrainian",
                                                        "value": "1058"
                                                    },
                                                    {
                                                        "label": "Slovenian",
                                                        "value": "1060"
                                                    },
                                                    {
                                                        "label": "Estonian",
                                                        "value": "1061"
                                                    },
                                                    {
                                                        "label": "Latvian",
                                                        "value": "1062"
                                                    },
                                                    {
                                                        "label": "Lithuanian",
                                                        "value": "1063"
                                                    },
                                                    {
                                                        "label": "Viatnamese",
                                                        "value": "1066"
                                                    },
                                                    {
                                                        "label": "Basque (Spain)",
                                                        "value": "1069"
                                                    },
                                                    {
                                                        "label": "Hindi (Latin)",
                                                        "value": "1081"
                                                    },
                                                    {
                                                        "label": "Malay",
                                                        "value": "1086"
                                                    },
                                                    {
                                                        "label": "Kazakh",
                                                        "value": "1087"
                                                    },
                                                    {
                                                        "label": "Galician (Spain)",
                                                        "value": "1110"
                                                    },
                                                    {
                                                        "label": "Chinese (Simplified)",
                                                        "value": "2052"
                                                    },
                                                    {
                                                        "label": "Portuguese",
                                                        "value": "2070"
                                                    },
                                                    {
                                                        "label": "Serbian (Latin)",
                                                        "value": "2074"
                                                    },
                                                    {
                                                        "label": "Chinese (Traditional)",
                                                        "value": "3076"
                                                    },
                                                    {
                                                        "label": "Modern Spanish (Spain)",
                                                        "value": "3082"
                                                    },
                                                    {
                                                        "label": "Serbian (Cyrillic)",
                                                        "value": "3089"
                                                    }
                                                ],
                                                "required": true
                                            }
                                        }
                                    },
                                    {
                                        "id": "ppCurrency",
                                        "header": "Currency",
                                        "width": "1fr",
                                        "element": {
                                            "name": "ppCurrencyDropDown",
                                            "type": "Microsoft.Common.DropDown",
                                            "placeholder": "Select a currency...",
                                            "filter": true,
                                            "constraints": {
                                                "allowedValues": [
                                                    {
                                                        "label": "AED",
                                                        "value": "aed"
                                                    },
                                                    {
                                                        "label": "AFN",
                                                        "value": "afn"
                                                    },
                                                    {
                                                        "label": "ALL",
                                                        "value": "all"
                                                    },
                                                    {
                                                        "label": "AMD",
                                                        "value": "amd"
                                                    },
                                                    {
                                                        "label": "ARS",
                                                        "value": "ars"
                                                    },
                                                    {
                                                        "label": "AUD",
                                                        "value": "aud"
                                                    },
                                                    {
                                                        "label": "AZN",
                                                        "value": "azn"
                                                    },
                                                    {
                                                        "label": "BAM",
                                                        "value": "bam"
                                                    },
                                                    {
                                                        "label": "BDT",
                                                        "value": "bdt"
                                                    },
                                                    {
                                                        "label": "BGN",
                                                        "value": "bgn"
                                                    },
                                                    {
                                                        "label": "BHD",
                                                        "value": "bhd"
                                                    },
                                                    {
                                                        "label": "BND",
                                                        "value": "bmd"
                                                    },
                                                    {
                                                        "label": "BOB",
                                                        "value": "bob"
                                                    },
                                                    {
                                                        "label": "BRL",
                                                        "value": "brl"
                                                    },
                                                    {
                                                        "label": "BTN",
                                                        "value": "btn"
                                                    },
                                                    {
                                                        "label": "BWP",
                                                        "value": "bwp"
                                                    },
                                                    {
                                                        "label": "BYN",
                                                        "value": "byn"
                                                    },
                                                    {
                                                        "label": "BZD",
                                                        "value": "bzd"
                                                    },
                                                    {
                                                        "label": "CAD",
                                                        "value": "cad"
                                                    },
                                                    {
                                                        "label": "CDF",
                                                        "value": "cdf"
                                                    },
                                                    {
                                                        "label": "CHF",
                                                        "value": "chf"
                                                    },
                                                    {
                                                        "label": "CLP",
                                                        "value": "clp"
                                                    },
                                                    {
                                                        "label": "CNY",
                                                        "value": "cny"
                                                    },
                                                    {
                                                        "label": "COP",
                                                        "value": "cop"
                                                    },
                                                    {
                                                        "label": "CRC",
                                                        "value": "crc"
                                                    },
                                                    {
                                                        "label": "CUP",
                                                        "value": "cup"
                                                    },
                                                    {
                                                        "label": "CZK",
                                                        "value": "czk"
                                                    },
                                                    {
                                                        "label": "DJF",
                                                        "value": "djf"
                                                    },
                                                    {
                                                        "label": "DKK",
                                                        "value": "dkk"
                                                    },
                                                    {
                                                        "label": "DOP",
                                                        "value": "dop"
                                                    },
                                                    {
                                                        "label": "DZD",
                                                        "value": "dzd"
                                                    },
                                                    {
                                                        "label": "EGP",
                                                        "value": "EGP"
                                                    },
                                                    {
                                                        "label": "ERN",
                                                        "value": "ERN"
                                                    },
                                                    {
                                                        "label": "ETB",
                                                        "value": "etb"
                                                    },
                                                    {
                                                        "label": "EUR",
                                                        "value": "eur"
                                                    },
                                                    {
                                                        "label": "GBP",
                                                        "value": "gbp"
                                                    },
                                                    {
                                                        "label": "GEL",
                                                        "value": "gel"
                                                    },
                                                    {
                                                        "label": "GTQ",
                                                        "value": "gtq"
                                                    },
                                                    {
                                                        "label": "HKD",
                                                        "value": "hkd"
                                                    },
                                                    {
                                                        "label": "HNL",
                                                        "value": "hnl"
                                                    },
                                                    {
                                                        "label": "HRK",
                                                        "value": "hrk"
                                                    },
                                                    {
                                                        "label": "HTG",
                                                        "value": "htg"
                                                    },
                                                    {
                                                        "label": "HUF",
                                                        "value": "huf"
                                                    },
                                                    {
                                                        "label": "IDR",
                                                        "value": "idr"
                                                    },
                                                    {
                                                        "label": "ILS",
                                                        "value": "ils"
                                                    },
                                                    {
                                                        "label": "INR",
                                                        "value": "inr"
                                                    },
                                                    {
                                                        "label": "IQD",
                                                        "value": "iqd"
                                                    },
                                                    {
                                                        "label": "IRR",
                                                        "value": "irr"
                                                    },
                                                    {
                                                        "label": "ISK",
                                                        "value": "isk"
                                                    },
                                                    {
                                                        "label": "JMD",
                                                        "value": "jmd"
                                                    },
                                                    {
                                                        "label": "JOD",
                                                        "value": "jod"
                                                    },
                                                    {
                                                        "label": "JPY",
                                                        "value": "jpy"
                                                    },
                                                    {
                                                        "label": "KES",
                                                        "value": "kes"
                                                    },
                                                    {
                                                        "label": "KGS",
                                                        "value": "kgs"
                                                    },
                                                    {
                                                        "label": "KHR",
                                                        "value": "khr"
                                                    },
                                                    {
                                                        "label": "KWR",
                                                        "value": "kwr"
                                                    },
                                                    {
                                                        "label": "KWD",
                                                        "value": "kwd"
                                                    },
                                                    {
                                                        "label": " KZT",
                                                        "value": "kzt"
                                                    },
                                                    {
                                                        "label": "LAK",
                                                        "value": "lak"
                                                    },
                                                    {
                                                        "label": "LBP",
                                                        "value": "lbp"
                                                    },
                                                    {
                                                        "label": "LKR",
                                                        "value": "lkr"
                                                    },
                                                    {
                                                        "label": "LYD",
                                                        "value": "lyd"
                                                    },
                                                    {
                                                        "label": "MAD",
                                                        "value": "mad"
                                                    },
                                                    {
                                                        "label": "MDL",
                                                        "value": "mdl"
                                                    },
                                                    {
                                                        "label": "MKD",
                                                        "value": "mkd"
                                                    },
                                                    {
                                                        "label": "MMK",
                                                        "value": "mmk"
                                                    },
                                                    {
                                                        "label": "MNT",
                                                        "value": "mnt"
                                                    },
                                                    {
                                                        "label": "MOP",
                                                        "value": "mop"
                                                    },
                                                    {
                                                        "label": "MVR",
                                                        "value": "mvr"
                                                    },
                                                    {
                                                        "label": "MXN",
                                                        "value": "mxn"
                                                    },
                                                    {
                                                        "label": "MYR",
                                                        "value": "myr"
                                                    },
                                                    {
                                                        "label": "NGN",
                                                        "value": "ngn"
                                                    },
                                                    {
                                                        "label": "NIO",
                                                        "value": " nio"
                                                    },
                                                    {
                                                        "label": "NOK",
                                                        "value": "nok"
                                                    },
                                                    {
                                                        "label": "NPR",
                                                        "value": "npr"
                                                    },
                                                    {
                                                        "label": "NZD",
                                                        "value": "nzd"
                                                    },
                                                    {
                                                        "label": "OMR",
                                                        "value": "omr"
                                                    },
                                                    {
                                                        "label": "PAB",
                                                        "value": "pab"
                                                    },
                                                    {
                                                        "label": "PEN",
                                                        "value": "pen"
                                                    },
                                                    {
                                                        "label": "PHP",
                                                        "value": "php"
                                                    },
                                                    {
                                                        "label": "PKR",
                                                        "value": "pkr"
                                                    },
                                                    {
                                                        "label": "PLN",
                                                        "value": "pln"
                                                    },
                                                    {
                                                        "label": "PYG",
                                                        "value": "pyg"
                                                    },
                                                    {
                                                        "label": "QAR",
                                                        "value": "qar"
                                                    },
                                                    {
                                                        "label": "RON",
                                                        "value": "ron"
                                                    },
                                                    {
                                                        "label": "RSD",
                                                        "value": "rds"
                                                    },
                                                    {
                                                        "label": "RUB",
                                                        "value": "rub"
                                                    },
                                                    {
                                                        "label": "RWF",
                                                        "value": "rwf"
                                                    },
                                                    {
                                                        "label": "SAR",
                                                        "value": "sar"
                                                    },
                                                    {
                                                        "label": "SEK",
                                                        "value": "sek"
                                                    },
                                                    {
                                                        "label": "SGD",
                                                        "value": "sgd"
                                                    },
                                                    {
                                                        "label": "SOS",
                                                        "value": "sos"
                                                    },
                                                    {
                                                        "label": "SYP",
                                                        "value": "syp"
                                                    },
                                                    {
                                                        "label": "THB",
                                                        "value": "thb"
                                                    },
                                                    {
                                                        "label": "TJS",
                                                        "value": "tjs"
                                                    },
                                                    {
                                                        "label": "TMT",
                                                        "value": "tmt"
                                                    },
                                                    {
                                                        "label": "TND",
                                                        "value": "tnd"
                                                    },
                                                    {
                                                        "label": "TRY",
                                                        "value": "try"
                                                    },
                                                    {
                                                        "label": "TTD",
                                                        "value": "ttd"
                                                    },
                                                    {
                                                        "label": "TWD",
                                                        "value": "twd"
                                                    },
                                                    {
                                                        "label": "UAH",
                                                        "value": "uah"
                                                    },
                                                    {
                                                        "label": "USD",
                                                        "value": "usd"
                                                    },
                                                    {
                                                        "label": "UYU",
                                                        "value": "uyu"
                                                    },
                                                    {
                                                        "label": "UZS",
                                                        "value": "uzs"
                                                    },
                                                    {
                                                        "label": "VES",
                                                        "value": "ves"
                                                    },
                                                    {
                                                        "label": "VND",
                                                        "value": "vnd"
                                                    },
                                                    {
                                                        "label": "XAF",
                                                        "value": "xaf"
                                                    },
                                                    {
                                                        "label": "XCD",
                                                        "value": "xcd"
                                                    },
                                                    {
                                                        "label": "XDR",
                                                        "value": "xdr"
                                                    },
                                                    {
                                                        "label": "XOF",
                                                        "value": "xof"
                                                    },
                                                    {
                                                        "label": "YER",
                                                        "value": "yer"
                                                    },
                                                    {
                                                        "label": "ZAR",
                                                        "value": "zar"
                                                    }
                                                ],
                                                "required": true
                                            }
                                        }
                                    },
                                    {
                                        "id": "ppRbac",
                                        "header": "Assign RBAC",
                                        "width": "2fr",
                                        "filter": true,
                                        "multiLine": true,
                                        "element": {
                                            "type": "Microsoft.Common.DropDown",
                                            "constraints": {
                                                "required": true,
                                                "allowedValues": "[coalesce(steps('landingZones').callGraph.transformed.list, parse('[]'))]"
                                            }
                                        }
                                    }
                                ]
                            }
                        },
                        {
                            "name": "ppCitizenCount",
                            "type": "Microsoft.Common.Slider",
                            "min": 1,
                            "max": 10,
                            "label": "Number of Environments for citizen developers to be created",
                            "subLabel": "Environments",
                            "defaultValue": 1,
                            "showStepMarkers": false,
                            "toolTip": "Select how many Environments you will create for citizen developers.",
                            "constraints": {
                                "required": false
                            },
                            "visible": "[equals(steps('landingZones').ppCitizen, 'yes')]"
                        },
                        {
                            "name": "ppCitizenNaming",
                            "type": "Microsoft.Common.TextBox",
                            "label": "Provide naming convention for the citizen developers environments",
                            "placeholder": "",
                            "defaultValue": "",
                            "toolTip": "Use only allowed characters",
                            "constraints": {
                                "required": true,
                                "regex": "^[a-z0-9A-Z]{1,30}$",
                                "validationMessage": "Only alphanumeric characters are allowed, and the value must be 1-30 characters long."
                            },
                            "visible": "[equals(steps('landingZones').ppCitizen, 'yes')]"
                        },
                        {
                            "name": "ppCitizenDescription",
                            "type": "Microsoft.Common.TextBox",
                            "label": "Provide a description for the citizen developers environments",
                            "placeholder": "",
                            "defaultValue": "",
                            "toolTip": "Provide general description for these Environments",
                            "constraints": {
                                "required": false,
                                "regex": "^[a-z0-9A-Z]{1,30}$"
                            },
                            "visible": "[equals(steps('landingZones').ppCitizen, 'yes')]"
                        },
                        {
                            "name": "ppCitizenRegion",
                            "type": "Microsoft.Common.DropDown",
                            "label": "Select region for the new Environments for citizen developers",
                            "placeholder": "",
                            "defaultValue": "",
                            "toolTip": "",
                            "filter": true,
                            "visible": "[equals(steps('landingZones').ppCitizen, 'yes')]",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Europe",
                                        "value": "europe"
                                    },
                                    {
                                        "label": "United States",
                                        "value": "unitedstates"
                                    },
                                    {
                                        "label": "United Arab Emirates",
                                        "value": "unitedarabemirates"
                                    },
                                    {
                                        "label": "Asia",
                                        "value": "asia"
                                    },
                                    {
                                        "label": "India",
                                        "value": "india"
                                    },
                                    {
                                        "label": "Japan",
                                        "value": "japan"
                                    },
                                    {
                                        "label": "France",
                                        "value": "france"
                                    },
                                    {
                                        "label": "Germany",
                                        "value": "germany"
                                    },
                                    {
                                        "label": "Australia",
                                        "value": "australia"
                                    },
                                    {
                                        "label": "Canada",
                                        "value": "canada"
                                    },
                                    {
                                        "label": "South America",
                                        "value": "southamerica"
                                    },
                                    {
                                        "label": "Norway",
                                        "value": "norway"
                                    }
                                ],
                                "required": true
                            }
                        },
                        {
                            "name": "ppCitizenLanguage",
                            "type": "Microsoft.Common.DropDown",
                            "label": "Select language for the new Environments for citizen developers",
                            "placeholder": "",
                            "defaultValue": "",
                            "toolTip": "",
                            "filter": true,
                            "visible": "[equals(steps('landingZones').ppCitizen, 'yes')]",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Arabic",
                                        "value": "1025"
                                    },
                                    {
                                        "label": "Bulgarian",
                                        "value": "1026"
                                    },
                                    {
                                        "label": "Catalan",
                                        "value": "1027"
                                    },
                                    {
                                        "label": "Chinese (Taiwan)",
                                        "value": "1028"
                                    },
                                    {
                                        "label": "Czech",
                                        "value": "1029"
                                    },
                                    {
                                        "label": "Danish",
                                        "value": "1030"
                                    },
                                    {
                                        "label": "German",
                                        "value": "1031"
                                    },
                                    {
                                        "label": "Greek",
                                        "value": "1032"
                                    },
                                    {
                                        "label": "English (United States)",
                                        "value": "1033"
                                    },
                                    {
                                        "label": "Finnish",
                                        "value": "1035"
                                    },
                                    {
                                        "label": "French",
                                        "value": "1036"
                                    },
                                    {
                                        "label": "Hebrew",
                                        "value": "1037"
                                    },
                                    {
                                        "label": "Hungarian",
                                        "value": "1038"
                                    },
                                    {
                                        "label": "Italian",
                                        "value": "1040"
                                    },
                                    {
                                        "label": "Japanese",
                                        "value": "1041"
                                    },
                                    {
                                        "label": "Korean",
                                        "value": "1042"
                                    },
                                    {
                                        "label": "Dutch",
                                        "value": "1043"
                                    },
                                    {
                                        "label": "Norwegian",
                                        "value": "1044"
                                    },
                                    {
                                        "label": "Polish",
                                        "value": "1045"
                                    },
                                    {
                                        "label": "Brazilian",
                                        "value": "1046"
                                    },
                                    {
                                        "label": "Romanian",
                                        "value": "1048"
                                    },
                                    {
                                        "label": "Russian",
                                        "value": "1049"
                                    },
                                    {
                                        "label": "Croatian",
                                        "value": "1050"
                                    },
                                    {
                                        "label": "Slovak",
                                        "value": "1051"
                                    },
                                    {
                                        "label": "Swedish",
                                        "value": "1053"
                                    },
                                    {
                                        "label": "Thai",
                                        "value": "1054"
                                    },
                                    {
                                        "label": "Turkish",
                                        "value": "1055"
                                    },
                                    {
                                        "label": "Indonesian",
                                        "value": "1057"
                                    },
                                    {
                                        "label": "Ukrainian",
                                        "value": "1058"
                                    },
                                    {
                                        "label": "Slovenian",
                                        "value": "1060"
                                    },
                                    {
                                        "label": "Estonian",
                                        "value": "1061"
                                    },
                                    {
                                        "label": "Latvian",
                                        "value": "1062"
                                    },
                                    {
                                        "label": "Lithuanian",
                                        "value": "1063"
                                    },
                                    {
                                        "label": "Viatnamese",
                                        "value": "1066"
                                    },
                                    {
                                        "label": "Basque (Spain)",
                                        "value": "1069"
                                    },
                                    {
                                        "label": "Hindi (Latin)",
                                        "value": "1081"
                                    },
                                    {
                                        "label": "Malay",
                                        "value": "1086"
                                    },
                                    {
                                        "label": "Kazakh",
                                        "value": "1087"
                                    },
                                    {
                                        "label": "Galician (Spain)",
                                        "value": "1110"
                                    },
                                    {
                                        "label": "Chinese (Simplified)",
                                        "value": "2052"
                                    },
                                    {
                                        "label": "Portuguese",
                                        "value": "2070"
                                    },
                                    {
                                        "label": "Serbian (Latin)",
                                        "value": "2074"
                                    },
                                    {
                                        "label": "Chinese (Traditional)",
                                        "value": "3076"
                                    },
                                    {
                                        "label": "Modern Spanish (Spain)",
                                        "value": "3082"
                                    },
                                    {
                                        "label": "Serbian (Cyrillic)",
                                        "value": "3089"
                                    }
                                ],
                                "required": true
                            }
                        },
                        {
                            "name": "ppCitizenCurrency",
                            "type": "Microsoft.Common.DropDown",
                            "label": "Select currency for the new Environments for citizen developers",
                            "placeholder": "",
                            "defaultValue": "",
                            "toolTip": "",
                            "filter": true,
                            "visible": "[equals(steps('landingZones').ppCitizen, 'yes')]",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "AED",
                                        "value": "aed"
                                    },
                                    {
                                        "label": "AFN",
                                        "value": "afn"
                                    },
                                    {
                                        "label": "ALL",
                                        "value": "all"
                                    },
                                    {
                                        "label": "AMD",
                                        "value": "amd"
                                    },
                                    {
                                        "label": "ARS",
                                        "value": "ars"
                                    },
                                    {
                                        "label": "AUD",
                                        "value": "aud"
                                    },
                                    {
                                        "label": "AZN",
                                        "value": "azn"
                                    },
                                    {
                                        "label": "BAM",
                                        "value": "bam"
                                    },
                                    {
                                        "label": "BDT",
                                        "value": "bdt"
                                    },
                                    {
                                        "label": "BGN",
                                        "value": "bgn"
                                    },
                                    {
                                        "label": "BHD",
                                        "value": "bhd"
                                    },
                                    {
                                        "label": "BND",
                                        "value": "bmd"
                                    },
                                    {
                                        "label": "BOB",
                                        "value": "bob"
                                    },
                                    {
                                        "label": "BRL",
                                        "value": "brl"
                                    },
                                    {
                                        "label": "BTN",
                                        "value": "btn"
                                    },
                                    {
                                        "label": "BWP",
                                        "value": "bwp"
                                    },
                                    {
                                        "label": "BYN",
                                        "value": "byn"
                                    },
                                    {
                                        "label": "BZD",
                                        "value": "bzd"
                                    },
                                    {
                                        "label": "CAD",
                                        "value": "cad"
                                    },
                                    {
                                        "label": "CDF",
                                        "value": "cdf"
                                    },
                                    {
                                        "label": "CHF",
                                        "value": "chf"
                                    },
                                    {
                                        "label": "CLP",
                                        "value": "clp"
                                    },
                                    {
                                        "label": "CNY",
                                        "value": "cny"
                                    },
                                    {
                                        "label": "COP",
                                        "value": "cop"
                                    },
                                    {
                                        "label": "CRC",
                                        "value": "crc"
                                    },
                                    {
                                        "label": "CUP",
                                        "value": "cup"
                                    },
                                    {
                                        "label": "CZK",
                                        "value": "czk"
                                    },
                                    {
                                        "label": "DJF",
                                        "value": "djf"
                                    },
                                    {
                                        "label": "DKK",
                                        "value": "dkk"
                                    },
                                    {
                                        "label": "DOP",
                                        "value": "dop"
                                    },
                                    {
                                        "label": "DZD",
                                        "value": "dzd"
                                    },
                                    {
                                        "label": "EGP",
                                        "value": "EGP"
                                    },
                                    {
                                        "label": "ERN",
                                        "value": "ERN"
                                    },
                                    {
                                        "label": "ETB",
                                        "value": "etb"
                                    },
                                    {
                                        "label": "EUR",
                                        "value": "eur"
                                    },
                                    {
                                        "label": "GBP",
                                        "value": "gbp"
                                    },
                                    {
                                        "label": "GEL",
                                        "value": "gel"
                                    },
                                    {
                                        "label": "GTQ",
                                        "value": "gtq"
                                    },
                                    {
                                        "label": "HKD",
                                        "value": "hkd"
                                    },
                                    {
                                        "label": "HNL",
                                        "value": "hnl"
                                    },
                                    {
                                        "label": "HRK",
                                        "value": "hrk"
                                    },
                                    {
                                        "label": "HTG",
                                        "value": "htg"
                                    },
                                    {
                                        "label": "HUF",
                                        "value": "huf"
                                    },
                                    {
                                        "label": "IDR",
                                        "value": "idr"
                                    },
                                    {
                                        "label": "ILS",
                                        "value": "ils"
                                    },
                                    {
                                        "label": "INR",
                                        "value": "inr"
                                    },
                                    {
                                        "label": "IQD",
                                        "value": "iqd"
                                    },
                                    {
                                        "label": "IRR",
                                        "value": "irr"
                                    },
                                    {
                                        "label": "ISK",
                                        "value": "isk"
                                    },
                                    {
                                        "label": "JMD",
                                        "value": "jmd"
                                    },
                                    {
                                        "label": "JOD",
                                        "value": "jod"
                                    },
                                    {
                                        "label": "JPY",
                                        "value": "jpy"
                                    },
                                    {
                                        "label": "KES",
                                        "value": "kes"
                                    },
                                    {
                                        "label": "KGS",
                                        "value": "kgs"
                                    },
                                    {
                                        "label": "KHR",
                                        "value": "khr"
                                    },
                                    {
                                        "label": "KWR",
                                        "value": "kwr"
                                    },
                                    {
                                        "label": "KWD",
                                        "value": "kwd"
                                    },
                                    {
                                        "label": " KZT",
                                        "value": "kzt"
                                    },
                                    {
                                        "label": "LAK",
                                        "value": "lak"
                                    },
                                    {
                                        "label": "LBP",
                                        "value": "lbp"
                                    },
                                    {
                                        "label": "LKR",
                                        "value": "lkr"
                                    },
                                    {
                                        "label": "LYD",
                                        "value": "lyd"
                                    },
                                    {
                                        "label": "MAD",
                                        "value": "mad"
                                    },
                                    {
                                        "label": "MDL",
                                        "value": "mdl"
                                    },
                                    {
                                        "label": "MKD",
                                        "value": "mkd"
                                    },
                                    {
                                        "label": "MMK",
                                        "value": "mmk"
                                    },
                                    {
                                        "label": "MNT",
                                        "value": "mnt"
                                    },
                                    {
                                        "label": "MOP",
                                        "value": "mop"
                                    },
                                    {
                                        "label": "MVR",
                                        "value": "mvr"
                                    },
                                    {
                                        "label": "MXN",
                                        "value": "mxn"
                                    },
                                    {
                                        "label": "MYR",
                                        "value": "myr"
                                    },
                                    {
                                        "label": "NGN",
                                        "value": "ngn"
                                    },
                                    {
                                        "label": "NIO",
                                        "value": " nio"
                                    },
                                    {
                                        "label": "NOK",
                                        "value": "nok"
                                    },
                                    {
                                        "label": "NPR",
                                        "value": "npr"
                                    },
                                    {
                                        "label": "NZD",
                                        "value": "nzd"
                                    },
                                    {
                                        "label": "OMR",
                                        "value": "omr"
                                    },
                                    {
                                        "label": "PAB",
                                        "value": "pab"
                                    },
                                    {
                                        "label": "PEN",
                                        "value": "pen"
                                    },
                                    {
                                        "label": "PHP",
                                        "value": "php"
                                    },
                                    {
                                        "label": "PKR",
                                        "value": "pkr"
                                    },
                                    {
                                        "label": "PLN",
                                        "value": "pln"
                                    },
                                    {
                                        "label": "PYG",
                                        "value": "pyg"
                                    },
                                    {
                                        "label": "QAR",
                                        "value": "qar"
                                    },
                                    {
                                        "label": "RON",
                                        "value": "ron"
                                    },
                                    {
                                        "label": "RSD",
                                        "value": "rds"
                                    },
                                    {
                                        "label": "RUB",
                                        "value": "rub"
                                    },
                                    {
                                        "label": "RWF",
                                        "value": "rwf"
                                    },
                                    {
                                        "label": "SAR",
                                        "value": "sar"
                                    },
                                    {
                                        "label": "SEK",
                                        "value": "sek"
                                    },
                                    {
                                        "label": "SGD",
                                        "value": "sgd"
                                    },
                                    {
                                        "label": "SOS",
                                        "value": "sos"
                                    },
                                    {
                                        "label": "SYP",
                                        "value": "syp"
                                    },
                                    {
                                        "label": "THB",
                                        "value": "thb"
                                    },
                                    {
                                        "label": "TJS",
                                        "value": "tjs"
                                    },
                                    {
                                        "label": "TMT",
                                        "value": "tmt"
                                    },
                                    {
                                        "label": "TND",
                                        "value": "tnd"
                                    },
                                    {
                                        "label": "TRY",
                                        "value": "try"
                                    },
                                    {
                                        "label": "TTD",
                                        "value": "ttd"
                                    },
                                    {
                                        "label": "TWD",
                                        "value": "twd"
                                    },
                                    {
                                        "label": "UAH",
                                        "value": "uah"
                                    },
                                    {
                                        "label": "USD",
                                        "value": "usd"
                                    },
                                    {
                                        "label": "UYU",
                                        "value": "uyu"
                                    },
                                    {
                                        "label": "UZS",
                                        "value": "uzs"
                                    },
                                    {
                                        "label": "VES",
                                        "value": "ves"
                                    },
                                    {
                                        "label": "VND",
                                        "value": "vnd"
                                    },
                                    {
                                        "label": "XAF",
                                        "value": "xaf"
                                    },
                                    {
                                        "label": "XCD",
                                        "value": "xcd"
                                    },
                                    {
                                        "label": "XDR",
                                        "value": "xdr"
                                    },
                                    {
                                        "label": "XOF",
                                        "value": "xof"
                                    },
                                    {
                                        "label": "YER",
                                        "value": "yer"
                                    },
                                    {
                                        "label": "ZAR",
                                        "value": "zar"
                                    }
                                ],
                                "required": true
                            }
                        },
                        {
                            "name": "ppCitizenDlp",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Assign recommended Data-loss prevention policies to the Environments for citizen development",
                            "defaultValue": "Yes (recommended)",
                            "multiSelect": true,
                            "toolTip": "If 'Yes' is selected, the setup will enable this",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            },
                            "visible": "[not(equals(steps('landingZones').ppCitizen, 'no'))]"
                        },
						{
                            "name": "ppCitizenManagedText",
                            "type": "Microsoft.Common.TextBlock",
                            "visible": true,
                            "options": {
                                "text": "Enabling Managed Environment in this step will opt-in to weekly digest, and allow you to continue the configuration in Power Platform Admin Center for sharing restrictions, DLPs and more post deployment.",
                                "link": {
                                    "label": "Learn more",
                                    "uri": "https://docs.microsoft.com/power-platform/admin/managed-environment-overview"
                                }
                            }
                        },
                        {
                            "name": "ppCitizenManagedEnv",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Enable Managed Environments (Preview) for the Environments for citizen development",
                            "defaultValue": "Yes (recommended)",
                            "toolTip": "Managed Environments is a suite of capabilities that allows admins to manage Power Platform at scale with more control, less effort, and more insights",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ],
                                "required": true
                            },
                            "visible": "[not(equals(steps('landingZones').ppCitizen, 'no'))]"
                        },
                        {
                            "name": "ppCitizenAlm",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Create Development, Test, and Production environments for each landing zone",
                            "defaultValue": "Yes (recommended)",
                            "toolTip": "If 'Yes' is selected, the setup adhere to best practices and create dedicated environments for sustainable application life-cycle management",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            },
                            "visible": "[not(equals(steps('landingZones').ppCitizen, 'no'))]"
                        },
                        {
                            "name": "ppCitizenBilling",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Create Billing Policy and Use Azure Subscription for pay-as-you-go for the citizen developer Environments",
                            "defaultValue": "Yes (recommended)",
                            "toolTip": "If 'Yes' is selected, the setup will enable it",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            },
                            "visible": "[not(equals(steps('landingZones').ppCitizen, 'no'))]"
                        },
                        {
                            "name": "proSection",
                            "type": "Microsoft.Common.Section",
                            "label": "Landing Zones for professional developers",
                            "elements": [],
                            "visible": true
                        },
                        {
                            "name": "proText",
                            "type": "Microsoft.Common.TextBlock",
                            "visible": true,
                            "options": {
                                "text": "The Landing Zones for professional developers will be optimized for enterprise application scenarios, and provide them with the required agility and simplicity to rapidly build robust enterprise applications with mature application lifecycle management. You can grant business units or indivuduals access to the Environments post creation.",
                                "link": {
                                    "label": "Learn more",
                                    "uri": "https://www.microsoft.com"
                                }
                            }
                        },
                        {
                            "name": "ppPro",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Create Environments for professional developer scenarios",
                            "defaultValue": "Yes",
                            "multiSelect": true,
                            "toolTip": "If 'Yes' is selected, the setup will create new environments for professional developer scenarios",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "Yes, and let me configure each Environment",
                                        "value": "custom"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            },
                            "visible": true
                        },
                        {
                            "name": "ppProConfiguration",
                            "type": "Microsoft.Common.EditableGrid",
                            "ariaLabel": "Create and Configure Pro Environment",
                            "label": "Professional Environment configuration",
                            "visible": "[equals(steps('landingZones').ppPro, 'custom')]",
                            "constraints": {
                                "width": "Full",
                                "rows": {
                                    "count": {
                                        "min": 1,
                                        "max": 10
                                    }
                                },
                                "columns": [
                                    {
                                        "id": "ppEnvName",
                                        "header": "Environment Name",
                                        "width": "1fr",
                                        "element": {
                                            "type": "Microsoft.Common.TextBox",
                                            "placeholder": "",
                                            "constraints": {
                                                "required": true,
                                                "validations": [
                                                    {
                                                        "regex": "^[a-z0-9A-Z]{1,30}$",
                                                        "message": "Only alphanumeric characters are allowed, and the value must be 1-30 characters long."
                                                    }
                                                ]
                                            }
                                        }
                                    },
                                    {
                                        "id": "ppEnvDescription",
                                        "header": "Description",
                                        "width": "1fr",
                                        "element": {
                                            "type": "Microsoft.Common.TextBox",
                                            "placeholder": "",
                                            "constraints": {
                                                "required": true,
                                                "validations": [
                                                    {
                                                        "regex": "^[a-z0-9A-Z]{1,30}$",
                                                        "message": "Only alphanumeric characters are allowed, and the value must be 1-30 characters long."
                                                    }
                                                ]
                                            }
                                        }
                                    },
                                    {
                                        "id": "ppRegion",
                                        "header": "Region",
                                        "width": "1fr",
                                        "element": {
                                            "name": "ppRegionDropDown",
                                            "type": "Microsoft.Common.DropDown",
                                            "filter": true,
                                            "placeholder": "Select a region...",
                                            "constraints": {
                                                "allowedValues": [
                                                    {
                                                        "label": "Europe",
                                                        "value": "europe"
                                                    },
                                                    {
                                                        "label": "United States",
                                                        "value": "unitedstates"
                                                    },
                                                    {
                                                        "label": "United Arab Emirates",
                                                        "value": "unitedarabemirates"
                                                    },
                                                    {
                                                        "label": "Asia",
                                                        "value": "asia"
                                                    },
                                                    {
                                                        "label": "India",
                                                        "value": "india"
                                                    },
                                                    {
                                                        "label": "Japan",
                                                        "value": "japan"
                                                    },
                                                    {
                                                        "label": "France",
                                                        "value": "france"
                                                    },
                                                    {
                                                        "label": "Germany",
                                                        "value": "germany"
                                                    },
                                                    {
                                                        "label": "Australia",
                                                        "value": "australia"
                                                    },
                                                    {
                                                        "label": "Canada",
                                                        "value": "canada"
                                                    },
                                                    {
                                                        "label": "South America",
                                                        "value": "southamerica"
                                                    },
                                                    {
                                                        "label": "Norway",
                                                        "value": "norway"
                                                    }
                                                ],
                                                "required": true
                                            }
                                        }
                                    },
                                    {
                                        "id": "ppLanguage",
                                        "header": "Language",
                                        "width": "1fr",
                                        "element": {
                                            "name": "ppLanguageDropDown",
                                            "type": "Microsoft.Common.DropDown",
                                            "placeholder": "Select a language...",
                                            "filter": true,
                                            "constraints": {
                                                "allowedValues": [
                                                    {
                                                        "label": "Arabic",
                                                        "value": "1025"
                                                    },
                                                    {
                                                        "label": "Bulgarian",
                                                        "value": "1026"
                                                    },
                                                    {
                                                        "label": "Catalan",
                                                        "value": "1027"
                                                    },
                                                    {
                                                        "label": "Chinese (Taiwan)",
                                                        "value": "1028"
                                                    },
                                                    {
                                                        "label": "Czech",
                                                        "value": "1029"
                                                    },
                                                    {
                                                        "label": "Danish",
                                                        "value": "1030"
                                                    },
                                                    {
                                                        "label": "German",
                                                        "value": "1031"
                                                    },
                                                    {
                                                        "label": "Greek",
                                                        "value": "1032"
                                                    },
                                                    {
                                                        "label": "English (United States)",
                                                        "value": "1033"
                                                    },
                                                    {
                                                        "label": "Finnish",
                                                        "value": "1035"
                                                    },
                                                    {
                                                        "label": "French",
                                                        "value": "1036"
                                                    },
                                                    {
                                                        "label": "Hebrew",
                                                        "value": "1037"
                                                    },
                                                    {
                                                        "label": "Hungarian",
                                                        "value": "1038"
                                                    },
                                                    {
                                                        "label": "Italian",
                                                        "value": "1040"
                                                    },
                                                    {
                                                        "label": "Japanese",
                                                        "value": "1041"
                                                    },
                                                    {
                                                        "label": "Korean",
                                                        "value": "1042"
                                                    },
                                                    {
                                                        "label": "Dutch",
                                                        "value": "1043"
                                                    },
                                                    {
                                                        "label": "Norwegian",
                                                        "value": "1044"
                                                    },
                                                    {
                                                        "label": "Polish",
                                                        "value": "1045"
                                                    },
                                                    {
                                                        "label": "Brazilian",
                                                        "value": "1046"
                                                    },
                                                    {
                                                        "label": "Romanian",
                                                        "value": "1048"
                                                    },
                                                    {
                                                        "label": "Russian",
                                                        "value": "1049"
                                                    },
                                                    {
                                                        "label": "Croatian",
                                                        "value": "1050"
                                                    },
                                                    {
                                                        "label": "Slovak",
                                                        "value": "1051"
                                                    },
                                                    {
                                                        "label": "Swedish",
                                                        "value": "1053"
                                                    },
                                                    {
                                                        "label": "Thai",
                                                        "value": "1054"
                                                    },
                                                    {
                                                        "label": "Turkish",
                                                        "value": "1055"
                                                    },
                                                    {
                                                        "label": "Indonesian",
                                                        "value": "1057"
                                                    },
                                                    {
                                                        "label": "Ukrainian",
                                                        "value": "1058"
                                                    },
                                                    {
                                                        "label": "Slovenian",
                                                        "value": "1060"
                                                    },
                                                    {
                                                        "label": "Estonian",
                                                        "value": "1061"
                                                    },
                                                    {
                                                        "label": "Latvian",
                                                        "value": "1062"
                                                    },
                                                    {
                                                        "label": "Lithuanian",
                                                        "value": "1063"
                                                    },
                                                    {
                                                        "label": "Viatnamese",
                                                        "value": "1066"
                                                    },
                                                    {
                                                        "label": "Basque (Spain)",
                                                        "value": "1069"
                                                    },
                                                    {
                                                        "label": "Hindi (Latin)",
                                                        "value": "1081"
                                                    },
                                                    {
                                                        "label": "Malay",
                                                        "value": "1086"
                                                    },
                                                    {
                                                        "label": "Kazakh",
                                                        "value": "1087"
                                                    },
                                                    {
                                                        "label": "Galician (Spain)",
                                                        "value": "1110"
                                                    },
                                                    {
                                                        "label": "Chinese (Simplified)",
                                                        "value": "2052"
                                                    },
                                                    {
                                                        "label": "Portuguese",
                                                        "value": "2070"
                                                    },
                                                    {
                                                        "label": "Serbian (Latin)",
                                                        "value": "2074"
                                                    },
                                                    {
                                                        "label": "Chinese (Traditional)",
                                                        "value": "3076"
                                                    },
                                                    {
                                                        "label": "Modern Spanish (Spain)",
                                                        "value": "3082"
                                                    },
                                                    {
                                                        "label": "Serbian (Cyrillic)",
                                                        "value": "3089"
                                                    }
                                                ],
                                                "required": true
                                            }
                                        }
                                    },
                                    {
                                        "id": "ppCurrency",
                                        "header": "Currency",
                                        "width": "1fr",
                                        "element": {
                                            "name": "ppCurrencyDropDown",
                                            "type": "Microsoft.Common.DropDown",
                                            "placeholder": "Select a currency...",
                                            "filter": true,
                                            "constraints": {
                                                "allowedValues": [
                                                    {
                                                        "label": "AED",
                                                        "value": "aed"
                                                    },
                                                    {
                                                        "label": "AFN",
                                                        "value": "afn"
                                                    },
                                                    {
                                                        "label": "ALL",
                                                        "value": "all"
                                                    },
                                                    {
                                                        "label": "AMD",
                                                        "value": "amd"
                                                    },
                                                    {
                                                        "label": "ARS",
                                                        "value": "ars"
                                                    },
                                                    {
                                                        "label": "AUD",
                                                        "value": "aud"
                                                    },
                                                    {
                                                        "label": "AZN",
                                                        "value": "azn"
                                                    },
                                                    {
                                                        "label": "BAM",
                                                        "value": "bam"
                                                    },
                                                    {
                                                        "label": "BDT",
                                                        "value": "bdt"
                                                    },
                                                    {
                                                        "label": "BGN",
                                                        "value": "bgn"
                                                    },
                                                    {
                                                        "label": "BHD",
                                                        "value": "bhd"
                                                    },
                                                    {
                                                        "label": "BND",
                                                        "value": "bmd"
                                                    },
                                                    {
                                                        "label": "BOB",
                                                        "value": "bob"
                                                    },
                                                    {
                                                        "label": "BRL",
                                                        "value": "brl"
                                                    },
                                                    {
                                                        "label": "BTN",
                                                        "value": "btn"
                                                    },
                                                    {
                                                        "label": "BWP",
                                                        "value": "bwp"
                                                    },
                                                    {
                                                        "label": "BYN",
                                                        "value": "byn"
                                                    },
                                                    {
                                                        "label": "BZD",
                                                        "value": "bzd"
                                                    },
                                                    {
                                                        "label": "CAD",
                                                        "value": "cad"
                                                    },
                                                    {
                                                        "label": "CDF",
                                                        "value": "cdf"
                                                    },
                                                    {
                                                        "label": "CHF",
                                                        "value": "chf"
                                                    },
                                                    {
                                                        "label": "CLP",
                                                        "value": "clp"
                                                    },
                                                    {
                                                        "label": "CNY",
                                                        "value": "cny"
                                                    },
                                                    {
                                                        "label": "COP",
                                                        "value": "cop"
                                                    },
                                                    {
                                                        "label": "CRC",
                                                        "value": "crc"
                                                    },
                                                    {
                                                        "label": "CUP",
                                                        "value": "cup"
                                                    },
                                                    {
                                                        "label": "CZK",
                                                        "value": "czk"
                                                    },
                                                    {
                                                        "label": "DJF",
                                                        "value": "djf"
                                                    },
                                                    {
                                                        "label": "DKK",
                                                        "value": "dkk"
                                                    },
                                                    {
                                                        "label": "DOP",
                                                        "value": "dop"
                                                    },
                                                    {
                                                        "label": "DZD",
                                                        "value": "dzd"
                                                    },
                                                    {
                                                        "label": "EGP",
                                                        "value": "EGP"
                                                    },
                                                    {
                                                        "label": "ERN",
                                                        "value": "ERN"
                                                    },
                                                    {
                                                        "label": "ETB",
                                                        "value": "etb"
                                                    },
                                                    {
                                                        "label": "EUR",
                                                        "value": "eur"
                                                    },
                                                    {
                                                        "label": "GBP",
                                                        "value": "gbp"
                                                    },
                                                    {
                                                        "label": "GEL",
                                                        "value": "gel"
                                                    },
                                                    {
                                                        "label": "GTQ",
                                                        "value": "gtq"
                                                    },
                                                    {
                                                        "label": "HKD",
                                                        "value": "hkd"
                                                    },
                                                    {
                                                        "label": "HNL",
                                                        "value": "hnl"
                                                    },
                                                    {
                                                        "label": "HRK",
                                                        "value": "hrk"
                                                    },
                                                    {
                                                        "label": "HTG",
                                                        "value": "htg"
                                                    },
                                                    {
                                                        "label": "HUF",
                                                        "value": "huf"
                                                    },
                                                    {
                                                        "label": "IDR",
                                                        "value": "idr"
                                                    },
                                                    {
                                                        "label": "ILS",
                                                        "value": "ils"
                                                    },
                                                    {
                                                        "label": "INR",
                                                        "value": "inr"
                                                    },
                                                    {
                                                        "label": "IQD",
                                                        "value": "iqd"
                                                    },
                                                    {
                                                        "label": "IRR",
                                                        "value": "irr"
                                                    },
                                                    {
                                                        "label": "ISK",
                                                        "value": "isk"
                                                    },
                                                    {
                                                        "label": "JMD",
                                                        "value": "jmd"
                                                    },
                                                    {
                                                        "label": "JOD",
                                                        "value": "jod"
                                                    },
                                                    {
                                                        "label": "JPY",
                                                        "value": "jpy"
                                                    },
                                                    {
                                                        "label": "KES",
                                                        "value": "kes"
                                                    },
                                                    {
                                                        "label": "KGS",
                                                        "value": "kgs"
                                                    },
                                                    {
                                                        "label": "KHR",
                                                        "value": "khr"
                                                    },
                                                    {
                                                        "label": "KWR",
                                                        "value": "kwr"
                                                    },
                                                    {
                                                        "label": "KWD",
                                                        "value": "kwd"
                                                    },
                                                    {
                                                        "label": " KZT",
                                                        "value": "kzt"
                                                    },
                                                    {
                                                        "label": "LAK",
                                                        "value": "lak"
                                                    },
                                                    {
                                                        "label": "LBP",
                                                        "value": "lbp"
                                                    },
                                                    {
                                                        "label": "LKR",
                                                        "value": "lkr"
                                                    },
                                                    {
                                                        "label": "LYD",
                                                        "value": "lyd"
                                                    },
                                                    {
                                                        "label": "MAD",
                                                        "value": "mad"
                                                    },
                                                    {
                                                        "label": "MDL",
                                                        "value": "mdl"
                                                    },
                                                    {
                                                        "label": "MKD",
                                                        "value": "mkd"
                                                    },
                                                    {
                                                        "label": "MMK",
                                                        "value": "mmk"
                                                    },
                                                    {
                                                        "label": "MNT",
                                                        "value": "mnt"
                                                    },
                                                    {
                                                        "label": "MOP",
                                                        "value": "mop"
                                                    },
                                                    {
                                                        "label": "MVR",
                                                        "value": "mvr"
                                                    },
                                                    {
                                                        "label": "MXN",
                                                        "value": "mxn"
                                                    },
                                                    {
                                                        "label": "MYR",
                                                        "value": "myr"
                                                    },
                                                    {
                                                        "label": "NGN",
                                                        "value": "ngn"
                                                    },
                                                    {
                                                        "label": "NIO",
                                                        "value": " nio"
                                                    },
                                                    {
                                                        "label": "NOK",
                                                        "value": "nok"
                                                    },
                                                    {
                                                        "label": "NPR",
                                                        "value": "npr"
                                                    },
                                                    {
                                                        "label": "NZD",
                                                        "value": "nzd"
                                                    },
                                                    {
                                                        "label": "OMR",
                                                        "value": "omr"
                                                    },
                                                    {
                                                        "label": "PAB",
                                                        "value": "pab"
                                                    },
                                                    {
                                                        "label": "PEN",
                                                        "value": "pen"
                                                    },
                                                    {
                                                        "label": "PHP",
                                                        "value": "php"
                                                    },
                                                    {
                                                        "label": "PKR",
                                                        "value": "pkr"
                                                    },
                                                    {
                                                        "label": "PLN",
                                                        "value": "pln"
                                                    },
                                                    {
                                                        "label": "PYG",
                                                        "value": "pyg"
                                                    },
                                                    {
                                                        "label": "QAR",
                                                        "value": "qar"
                                                    },
                                                    {
                                                        "label": "RON",
                                                        "value": "ron"
                                                    },
                                                    {
                                                        "label": "RSD",
                                                        "value": "rds"
                                                    },
                                                    {
                                                        "label": "RUB",
                                                        "value": "rub"
                                                    },
                                                    {
                                                        "label": "RWF",
                                                        "value": "rwf"
                                                    },
                                                    {
                                                        "label": "SAR",
                                                        "value": "sar"
                                                    },
                                                    {
                                                        "label": "SEK",
                                                        "value": "sek"
                                                    },
                                                    {
                                                        "label": "SGD",
                                                        "value": "sgd"
                                                    },
                                                    {
                                                        "label": "SOS",
                                                        "value": "sos"
                                                    },
                                                    {
                                                        "label": "SYP",
                                                        "value": "syp"
                                                    },
                                                    {
                                                        "label": "THB",
                                                        "value": "thb"
                                                    },
                                                    {
                                                        "label": "TJS",
                                                        "value": "tjs"
                                                    },
                                                    {
                                                        "label": "TMT",
                                                        "value": "tmt"
                                                    },
                                                    {
                                                        "label": "TND",
                                                        "value": "tnd"
                                                    },
                                                    {
                                                        "label": "TRY",
                                                        "value": "try"
                                                    },
                                                    {
                                                        "label": "TTD",
                                                        "value": "ttd"
                                                    },
                                                    {
                                                        "label": "TWD",
                                                        "value": "twd"
                                                    },
                                                    {
                                                        "label": "UAH",
                                                        "value": "uah"
                                                    },
                                                    {
                                                        "label": "USD",
                                                        "value": "usd"
                                                    },
                                                    {
                                                        "label": "UYU",
                                                        "value": "uyu"
                                                    },
                                                    {
                                                        "label": "UZS",
                                                        "value": "uzs"
                                                    },
                                                    {
                                                        "label": "VES",
                                                        "value": "ves"
                                                    },
                                                    {
                                                        "label": "VND",
                                                        "value": "vnd"
                                                    },
                                                    {
                                                        "label": "XAF",
                                                        "value": "xaf"
                                                    },
                                                    {
                                                        "label": "XCD",
                                                        "value": "xcd"
                                                    },
                                                    {
                                                        "label": "XDR",
                                                        "value": "xdr"
                                                    },
                                                    {
                                                        "label": "XOF",
                                                        "value": "xof"
                                                    },
                                                    {
                                                        "label": "YER",
                                                        "value": "yer"
                                                    },
                                                    {
                                                        "label": "ZAR",
                                                        "value": "zar"
                                                    }
                                                ],
                                                "required": true
                                            }
                                        }
                                    },
                                    {
                                        "id": "ppRbac",
                                        "header": "Assign RBAC",
                                        "width": "2fr",
                                        "filter": true,
                                        "multiLine": true,
                                        "element": {
                                            "type": "Microsoft.Common.DropDown",
                                            "constraints": {
                                                "required": true,
                                                "allowedValues": "[coalesce(steps('landingZones').callGraph.transformed.list, parse('[]'))]"
                                            }
                                        }
                                    }
                                ]
                            }
                        },
                        {
                            "name": "ppProCount",
                            "type": "Microsoft.Common.Slider",
                            "min": 1,
                            "max": 10,
                            "label": "Number of Environments for professional developers to be created",
                            "subLabel": "Environments",
                            "defaultValue": 1,
                            "showStepMarkers": false,
                            "toolTip": "Select how many Environments you will create for professional developers.",
                            "constraints": {
                                "required": false
                            },
                            "visible": "[equals(steps('landingZones').ppPro, 'yes')]"
                        },
                        {
                            "name": "ppProNaming",
                            "type": "Microsoft.Common.TextBox",
                            "label": "Provide naming convention for the professional developers environments",
                            "placeholder": "",
                            "defaultValue": "",
                            "toolTip": "Use only allowed characters",
                            "constraints": {
                                "required": true,
                                "regex": "^[a-z0-9A-Z]{1,30}$",
                                "validationMessage": "Only alphanumeric characters are allowed, and the value must be 1-30 characters long."
                            },
                            "visible": "[equals(steps('landingZones').ppPro, 'yes')]"
                        },
                        {
                            "name": "ppProDescription",
                            "type": "Microsoft.Common.TextBox",
                            "label": "Provide a description for the professional developers environments",
                            "placeholder": "",
                            "defaultValue": "",
                            "toolTip": "Provide general description for these Environments",
                            "constraints": {
                                "required": false,
                                "regex": "^[a-z0-9A-Z]{1,30}$"
                            },
                            "visible": "[equals(steps('landingZones').ppPro, 'yes')]"
                        },
                        {
                            "name": "ppProRegion",
                            "type": "Microsoft.Common.DropDown",
                            "label": "Select region for the new Environments for professional developers",
                            "placeholder": "",
                            "defaultValue": "",
                            "toolTip": "",
                            "visible": "[equals(steps('landingZones').ppPro, 'yes')]",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Europe",
                                        "value": "europe"
                                    },
                                    {
                                        "label": "United States",
                                        "value": "unitedstates"
                                    },
                                    {
                                        "label": "United Arab Emirates",
                                        "value": "unitedarabemirates"
                                    },
                                    {
                                        "label": "Asia",
                                        "value": "asia"
                                    },
                                    {
                                        "label": "India",
                                        "value": "india"
                                    },
                                    {
                                        "label": "Japan",
                                        "value": "japan"
                                    },
                                    {
                                        "label": "France",
                                        "value": "france"
                                    },
                                    {
                                        "label": "Germany",
                                        "value": "germany"
                                    },
                                    {
                                        "label": "Australia",
                                        "value": "australia"
                                    },
                                    {
                                        "label": "Canada",
                                        "value": "canada"
                                    },
                                    {
                                        "label": "South America",
                                        "value": "southamerica"
                                    },
                                    {
                                        "label": "Norway",
                                        "value": "norway"
                                    }
                                ],
                                "required": true
                            }
                        },
                        {
                            "name": "ppProLanguage",
                            "type": "Microsoft.Common.DropDown",
                            "label": "Select language for the new Environments for professional developers",
                            "placeholder": "",
                            "defaultValue": "",
                            "toolTip": "",
                            "filter": true,
                            "visible": "[equals(steps('landingZones').ppPro, 'yes')]",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Arabic",
                                        "value": "1025"
                                    },
                                    {
                                        "label": "Bulgarian",
                                        "value": "1026"
                                    },
                                    {
                                        "label": "Catalan",
                                        "value": "1027"
                                    },
                                    {
                                        "label": "Chinese (Taiwan)",
                                        "value": "1028"
                                    },
                                    {
                                        "label": "Czech",
                                        "value": "1029"
                                    },
                                    {
                                        "label": "Danish",
                                        "value": "1030"
                                    },
                                    {
                                        "label": "German",
                                        "value": "1031"
                                    },
                                    {
                                        "label": "Greek",
                                        "value": "1032"
                                    },
                                    {
                                        "label": "English (United States)",
                                        "value": "1033"
                                    },
                                    {
                                        "label": "Finnish",
                                        "value": "1035"
                                    },
                                    {
                                        "label": "French",
                                        "value": "1036"
                                    },
                                    {
                                        "label": "Hebrew",
                                        "value": "1037"
                                    },
                                    {
                                        "label": "Hungarian",
                                        "value": "1038"
                                    },
                                    {
                                        "label": "Italian",
                                        "value": "1040"
                                    },
                                    {
                                        "label": "Japanese",
                                        "value": "1041"
                                    },
                                    {
                                        "label": "Korean",
                                        "value": "1042"
                                    },
                                    {
                                        "label": "Dutch",
                                        "value": "1043"
                                    },
                                    {
                                        "label": "Norwegian",
                                        "value": "1044"
                                    },
                                    {
                                        "label": "Polish",
                                        "value": "1045"
                                    },
                                    {
                                        "label": "Brazilian",
                                        "value": "1046"
                                    },
                                    {
                                        "label": "Romanian",
                                        "value": "1048"
                                    },
                                    {
                                        "label": "Russian",
                                        "value": "1049"
                                    },
                                    {
                                        "label": "Croatian",
                                        "value": "1050"
                                    },
                                    {
                                        "label": "Slovak",
                                        "value": "1051"
                                    },
                                    {
                                        "label": "Swedish",
                                        "value": "1053"
                                    },
                                    {
                                        "label": "Thai",
                                        "value": "1054"
                                    },
                                    {
                                        "label": "Turkish",
                                        "value": "1055"
                                    },
                                    {
                                        "label": "Indonesian",
                                        "value": "1057"
                                    },
                                    {
                                        "label": "Ukrainian",
                                        "value": "1058"
                                    },
                                    {
                                        "label": "Slovenian",
                                        "value": "1060"
                                    },
                                    {
                                        "label": "Estonian",
                                        "value": "1061"
                                    },
                                    {
                                        "label": "Latvian",
                                        "value": "1062"
                                    },
                                    {
                                        "label": "Lithuanian",
                                        "value": "1063"
                                    },
                                    {
                                        "label": "Viatnamese",
                                        "value": "1066"
                                    },
                                    {
                                        "label": "Basque (Spain)",
                                        "value": "1069"
                                    },
                                    {
                                        "label": "Hindi (Latin)",
                                        "value": "1081"
                                    },
                                    {
                                        "label": "Malay",
                                        "value": "1086"
                                    },
                                    {
                                        "label": "Kazakh",
                                        "value": "1087"
                                    },
                                    {
                                        "label": "Galician (Spain)",
                                        "value": "1110"
                                    },
                                    {
                                        "label": "Chinese (Simplified)",
                                        "value": "2052"
                                    },
                                    {
                                        "label": "Portuguese",
                                        "value": "2070"
                                    },
                                    {
                                        "label": "Serbian (Latin)",
                                        "value": "2074"
                                    },
                                    {
                                        "label": "Chinese (Traditional)",
                                        "value": "3076"
                                    },
                                    {
                                        "label": "Modern Spanish (Spain)",
                                        "value": "3082"
                                    },
                                    {
                                        "label": "Serbian (Cyrillic)",
                                        "value": "3089"
                                    }
                                ],
                                "required": true
                            }
                        },
                        {
                            "name": "ppProCurrency",
                            "type": "Microsoft.Common.DropDown",
                            "label": "Select currency for the new Environments for professional developers",
                            "placeholder": "",
                            "defaultValue": "",
                            "toolTip": "",
                            "filter": true,
                            "visible": "[equals(steps('landingZones').ppPro, 'yes')]",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "AED",
                                        "value": "aed"
                                    },
                                    {
                                        "label": "AFN",
                                        "value": "afn"
                                    },
                                    {
                                        "label": "ALL",
                                        "value": "all"
                                    },
                                    {
                                        "label": "AMD",
                                        "value": "amd"
                                    },
                                    {
                                        "label": "ARS",
                                        "value": "ars"
                                    },
                                    {
                                        "label": "AUD",
                                        "value": "aud"
                                    },
                                    {
                                        "label": "AZN",
                                        "value": "azn"
                                    },
                                    {
                                        "label": "BAM",
                                        "value": "bam"
                                    },
                                    {
                                        "label": "BDT",
                                        "value": "bdt"
                                    },
                                    {
                                        "label": "BGN",
                                        "value": "bgn"
                                    },
                                    {
                                        "label": "BHD",
                                        "value": "bhd"
                                    },
                                    {
                                        "label": "BND",
                                        "value": "bmd"
                                    },
                                    {
                                        "label": "BOB",
                                        "value": "bob"
                                    },
                                    {
                                        "label": "BRL",
                                        "value": "brl"
                                    },
                                    {
                                        "label": "BTN",
                                        "value": "btn"
                                    },
                                    {
                                        "label": "BWP",
                                        "value": "bwp"
                                    },
                                    {
                                        "label": "BYN",
                                        "value": "byn"
                                    },
                                    {
                                        "label": "BZD",
                                        "value": "bzd"
                                    },
                                    {
                                        "label": "CAD",
                                        "value": "cad"
                                    },
                                    {
                                        "label": "CDF",
                                        "value": "cdf"
                                    },
                                    {
                                        "label": "CHF",
                                        "value": "chf"
                                    },
                                    {
                                        "label": "CLP",
                                        "value": "clp"
                                    },
                                    {
                                        "label": "CNY",
                                        "value": "cny"
                                    },
                                    {
                                        "label": "COP",
                                        "value": "cop"
                                    },
                                    {
                                        "label": "CRC",
                                        "value": "crc"
                                    },
                                    {
                                        "label": "CUP",
                                        "value": "cup"
                                    },
                                    {
                                        "label": "CZK",
                                        "value": "czk"
                                    },
                                    {
                                        "label": "DJF",
                                        "value": "djf"
                                    },
                                    {
                                        "label": "DKK",
                                        "value": "dkk"
                                    },
                                    {
                                        "label": "DOP",
                                        "value": "dop"
                                    },
                                    {
                                        "label": "DZD",
                                        "value": "dzd"
                                    },
                                    {
                                        "label": "EGP",
                                        "value": "EGP"
                                    },
                                    {
                                        "label": "ERN",
                                        "value": "ERN"
                                    },
                                    {
                                        "label": "ETB",
                                        "value": "etb"
                                    },
                                    {
                                        "label": "EUR",
                                        "value": "eur"
                                    },
                                    {
                                        "label": "GBP",
                                        "value": "gbp"
                                    },
                                    {
                                        "label": "GEL",
                                        "value": "gel"
                                    },
                                    {
                                        "label": "GTQ",
                                        "value": "gtq"
                                    },
                                    {
                                        "label": "HKD",
                                        "value": "hkd"
                                    },
                                    {
                                        "label": "HNL",
                                        "value": "hnl"
                                    },
                                    {
                                        "label": "HRK",
                                        "value": "hrk"
                                    },
                                    {
                                        "label": "HTG",
                                        "value": "htg"
                                    },
                                    {
                                        "label": "HUF",
                                        "value": "huf"
                                    },
                                    {
                                        "label": "IDR",
                                        "value": "idr"
                                    },
                                    {
                                        "label": "ILS",
                                        "value": "ils"
                                    },
                                    {
                                        "label": "INR",
                                        "value": "inr"
                                    },
                                    {
                                        "label": "IQD",
                                        "value": "iqd"
                                    },
                                    {
                                        "label": "IRR",
                                        "value": "irr"
                                    },
                                    {
                                        "label": "ISK",
                                        "value": "isk"
                                    },
                                    {
                                        "label": "JMD",
                                        "value": "jmd"
                                    },
                                    {
                                        "label": "JOD",
                                        "value": "jod"
                                    },
                                    {
                                        "label": "JPY",
                                        "value": "jpy"
                                    },
                                    {
                                        "label": "KES",
                                        "value": "kes"
                                    },
                                    {
                                        "label": "KGS",
                                        "value": "kgs"
                                    },
                                    {
                                        "label": "KHR",
                                        "value": "khr"
                                    },
                                    {
                                        "label": "KWR",
                                        "value": "kwr"
                                    },
                                    {
                                        "label": "KWD",
                                        "value": "kwd"
                                    },
                                    {
                                        "label": " KZT",
                                        "value": "kzt"
                                    },
                                    {
                                        "label": "LAK",
                                        "value": "lak"
                                    },
                                    {
                                        "label": "LBP",
                                        "value": "lbp"
                                    },
                                    {
                                        "label": "LKR",
                                        "value": "lkr"
                                    },
                                    {
                                        "label": "LYD",
                                        "value": "lyd"
                                    },
                                    {
                                        "label": "MAD",
                                        "value": "mad"
                                    },
                                    {
                                        "label": "MDL",
                                        "value": "mdl"
                                    },
                                    {
                                        "label": "MKD",
                                        "value": "mkd"
                                    },
                                    {
                                        "label": "MMK",
                                        "value": "mmk"
                                    },
                                    {
                                        "label": "MNT",
                                        "value": "mnt"
                                    },
                                    {
                                        "label": "MOP",
                                        "value": "mop"
                                    },
                                    {
                                        "label": "MVR",
                                        "value": "mvr"
                                    },
                                    {
                                        "label": "MXN",
                                        "value": "mxn"
                                    },
                                    {
                                        "label": "MYR",
                                        "value": "myr"
                                    },
                                    {
                                        "label": "NGN",
                                        "value": "ngn"
                                    },
                                    {
                                        "label": "NIO",
                                        "value": " nio"
                                    },
                                    {
                                        "label": "NOK",
                                        "value": "nok"
                                    },
                                    {
                                        "label": "NPR",
                                        "value": "npr"
                                    },
                                    {
                                        "label": "NZD",
                                        "value": "nzd"
                                    },
                                    {
                                        "label": "OMR",
                                        "value": "omr"
                                    },
                                    {
                                        "label": "PAB",
                                        "value": "pab"
                                    },
                                    {
                                        "label": "PEN",
                                        "value": "pen"
                                    },
                                    {
                                        "label": "PHP",
                                        "value": "php"
                                    },
                                    {
                                        "label": "PKR",
                                        "value": "pkr"
                                    },
                                    {
                                        "label": "PLN",
                                        "value": "pln"
                                    },
                                    {
                                        "label": "PYG",
                                        "value": "pyg"
                                    },
                                    {
                                        "label": "QAR",
                                        "value": "qar"
                                    },
                                    {
                                        "label": "RON",
                                        "value": "ron"
                                    },
                                    {
                                        "label": "RSD",
                                        "value": "rds"
                                    },
                                    {
                                        "label": "RUB",
                                        "value": "rub"
                                    },
                                    {
                                        "label": "RWF",
                                        "value": "rwf"
                                    },
                                    {
                                        "label": "SAR",
                                        "value": "sar"
                                    },
                                    {
                                        "label": "SEK",
                                        "value": "sek"
                                    },
                                    {
                                        "label": "SGD",
                                        "value": "sgd"
                                    },
                                    {
                                        "label": "SOS",
                                        "value": "sos"
                                    },
                                    {
                                        "label": "SYP",
                                        "value": "syp"
                                    },
                                    {
                                        "label": "THB",
                                        "value": "thb"
                                    },
                                    {
                                        "label": "TJS",
                                        "value": "tjs"
                                    },
                                    {
                                        "label": "TMT",
                                        "value": "tmt"
                                    },
                                    {
                                        "label": "TND",
                                        "value": "tnd"
                                    },
                                    {
                                        "label": "TRY",
                                        "value": "try"
                                    },
                                    {
                                        "label": "TTD",
                                        "value": "ttd"
                                    },
                                    {
                                        "label": "TWD",
                                        "value": "twd"
                                    },
                                    {
                                        "label": "UAH",
                                        "value": "uah"
                                    },
                                    {
                                        "label": "USD",
                                        "value": "usd"
                                    },
                                    {
                                        "label": "UYU",
                                        "value": "uyu"
                                    },
                                    {
                                        "label": "UZS",
                                        "value": "uzs"
                                    },
                                    {
                                        "label": "VES",
                                        "value": "ves"
                                    },
                                    {
                                        "label": "VND",
                                        "value": "vnd"
                                    },
                                    {
                                        "label": "XAF",
                                        "value": "xaf"
                                    },
                                    {
                                        "label": "XCD",
                                        "value": "xcd"
                                    },
                                    {
                                        "label": "XDR",
                                        "value": "xdr"
                                    },
                                    {
                                        "label": "XOF",
                                        "value": "xof"
                                    },
                                    {
                                        "label": "YER",
                                        "value": "yer"
                                    },
                                    {
                                        "label": "ZAR",
                                        "value": "zar"
                                    }
                                ],
                                "required": true
                            }
                        },
                        {
                            "name": "ppProDlp",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Assign recommended Data-loss prevention policies to the Environments for professional development",
                            "defaultValue": "Yes (recommended)",
                            "multiSelect": true,
                            "toolTip": "If 'Yes' is selected, the setup will enable this",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            },
                            "visible": "[not(equals(steps('landingZones').ppPro, 'no'))]"
                        },
						{
                            "name": "ppProManagedText",
                            "type": "Microsoft.Common.TextBlock",
                            "visible": true,
                            "options": {
                                "text": "Enabling Managed Environment in this step will opt-in to weekly digest, and allow you to continue the configuration in Power Platform Admin Center for sharing restrictions, DLPs and more post deployment.",
                                "link": {
                                    "label": "Learn more",
                                    "uri": "https://docs.microsoft.com/power-platform/admin/managed-environment-overview"
                                }
                            }
                        },
                        {
                            "name": "ppProManagedEnv",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Enable Managed Environments (Preview) for the Environments for professional development",
                            "defaultValue": "Yes (recommended)",
                            "toolTip": "Managed Environments is a suite of capabilities that allows admins to manage Power Platform at scale with more control, less effort, and more insights",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ],
                                "required": true
                            },
                            "visible": "[not(equals(steps('landingZones').ppPro, 'no'))]"
                        },
                        {
                            "name": "ppProAlm",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Create Development, Test, and Production environments for each landing zone",
                            "defaultValue": "Yes (recommended)",
                            "toolTip": "If 'Yes' is selected, the setup will enable it, and adhere to best practices and create dedicated environments for sustainable application life-cycle management",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            },
                            "visible": "[not(equals(steps('landingZones').ppPro, 'no'))]"
                        },
                        {
                            "name": "ppProBilling",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Create Billing Policy and Use Azure Subscription for pay-as-you-go for the professional developer Environments",
                            "defaultValue": "Yes (recommended)",
                            "toolTip": "If 'Yes' is selected, the setup will enable it",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            },
                            "visible": "[not(equals(steps('landingZones').ppPro, 'no'))]"
                        },
                        {
                            "name": "industrySection",
                            "type": "Microsoft.Common.Section",
                            "label": "Landing Zones for Industry Clouds",
                            "elements": [],
                            "visible": true
                        },
                        {
                            "name": "industryText",
                            "type": "Microsoft.Common.TextBlock",
                            "visible": true,
                            "options": {
                                "text": "The Landing Zones for Industry Clouds are intended to host your D365 applications and Industry Solutions. Once created, you can add the Industry Clouds using 'Microsoft Cloud Solution Center'",
                                "link": {
                                    "label": "Microsoft Cloud Solution Center",
                                    "uri": "https://solutions.microsoft.com/"
                                }
                            }
                        },
                        {
                            "name": "ppIndustry",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Create Environments for Industry Clouds",
                            "defaultValue": "Yes",
                            "multiSelect": false,
                            "toolTip": "If 'Yes' is selected, the setup will create new environments for Industry scenarios (requires Dataverse)",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            },
                            "visible": true
                        },
                        {
                            "name": "ppSelectIndustry",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Select Microsoft Cloud for Industry",
                            "defaultValue": "None",
                            "multiSelect": false,
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "None",
                                        "value": "none"
                                    },
                                    {
                                        "label": "Healthcare",
                                        "value": "healthcare"
                                    },
                                    {
                                        "label": "Financial Services",
                                        "value": "fsi"
                                    },
                                    {
                                        "label": "Retail",
                                        "value": "retail"
                                    }
                                ]
                            },
                            "visible": "[not(equals(steps('landingZones').ppIndustry, 'no'))]"
                        },
                        {
                            "name": "ppIndustryNaming",
                            "type": "Microsoft.Common.TextBox",
                            "label": "Provide naming convention for the industry environments",
                            "placeholder": "",
                            "defaultValue": "",
                            "toolTip": "Use only allowed characters",
                            "constraints": {
                                "required": true,
                                "regex": "^[a-z0-9A-Z]{1,30}$",
                                "validationMessage": "Only alphanumeric characters are allowed, and the value must be 1-30 characters long."
                            },
                            "visible": "[not(equals(steps('landingZones').ppIndustry, 'no'))]"
                        },
                        {
                            "name": "ppIndustryRegion",
                            "type": "Microsoft.Common.DropDown",
                            "label": "Select region for the new Environments for the industry clouds",
                            "placeholder": "",
                            "defaultValue": "",
                            "toolTip": "",
                            "visible": "[equals(steps('landingZones').ppIndustry, 'yes')]",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Europe",
                                        "value": "europe"
                                    },
                                    {
                                        "label": "United States",
                                        "value": "unitedstates"
                                    },
                                    {
                                        "label": "United Arab Emirates",
                                        "value": "unitedarabemirates"
                                    },
                                    {
                                        "label": "Asia",
                                        "value": "asia"
                                    },
                                    {
                                        "label": "India",
                                        "value": "india"
                                    },
                                    {
                                        "label": "Japan",
                                        "value": "japan"
                                    },
                                    {
                                        "label": "France",
                                        "value": "france"
                                    },
                                    {
                                        "label": "Germany",
                                        "value": "germany"
                                    },
                                    {
                                        "label": "Australia",
                                        "value": "australia"
                                    },
                                    {
                                        "label": "Canada",
                                        "value": "canada"
                                    },
                                    {
                                        "label": "South America",
                                        "value": "southamerica"
                                    },
                                    {
                                        "label": "Norway",
                                        "value": "norway"
                                    }
                                ],
                                "required": true
                            }
                        },
						{
                            "name": "ppIndustryManagedText",
                            "type": "Microsoft.Common.TextBlock",
                            "visible": true,
                            "options": {
                                "text": "Enabling Managed Environment in this step will opt-in to weekly digest, and allow you to continue the configuration in Power Platform Admin Center for sharing restrictions, DLPs and more post deployment.",
                                "link": {
                                    "label": "Learn more",
                                    "uri": "https://docs.microsoft.com/power-platform/admin/managed-environment-overview"
                                }
                            }
                        },
                        {
                            "name": "ppIndustryManagedEnv",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Enable Managed Environments (Preview) for the Environments for industry cloud",
                            "defaultValue": "Yes (recommended)",
                            "toolTip": "Managed Environments is a suite of capabilities that allows admins to manage Power Platform at scale with more control, less effort, and more insights",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ],
                                "required": true
                            },
                            "visible": "[not(equals(steps('landingZones').ppIndustry, 'no'))]"
                        },
                        {
                            "name": "ppIndustryAlm",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Create Development, Test, and Production environments for each landing zone",
                            "defaultValue": "Yes (recommended)",
                            "toolTip": "If 'Yes' is selected, the setup will enable it",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            },
                            "visible": "[equals(steps('landingZones').ppIndustry, 'yes')]"
                        },
                        {
                            "name": "ppIndustryBilling",
                            "type": "Microsoft.Common.OptionsGroup",
                            "label": "Create Billing Policy and Use Azure Subscription for pay-as-you-go for the Industry Environments",
                            "defaultValue": "Yes (recommended)",
                            "toolTip": "If 'Yes' is selected, the setup will enable it",
                            "constraints": {
                                "allowedValues": [
                                    {
                                        "label": "Yes (recommended)",
                                        "value": "yes"
                                    },
                                    {
                                        "label": "No",
                                        "value": "no"
                                    }
                                ]
                            },
                            "visible": "[equals(steps('landingZones').ppIndustry, 'yes')]"
                        }
                    ]
                }
            ]
        },
        "outputs": {
            "parameters": {
                "ppIdentity": "[steps('powerp').ppIdentity.id]",
                "ppTenantDlp": "[steps('gov').ppTenantDlp]",
                "ppTenantIsolationDomains": "[steps('gov').ppTenantIsolationDomains]",
                "ppTenantIsolationSetting": "[steps('gov').ppTenantIsolationSetting]",
                "ppGuestMakerSetting": "[steps('gov').ppGuestMakerSetting]",
                "ppAppSharingSetting": "[steps('gov').ppAppSharingSetting]",
                "ppEnvCreationSetting": "[steps('environments').ppEnvCreationSetting]",
                "ppTrialEnvCreationSetting": "[steps('environments').ppTrialEnvCreationSetting]",
                "ppEnvCapacitySetting": "[steps('environments').ppEnvCapacitySetting]",
                "ppAdminEnvEnablement": "[steps('environments').ppAdminEnvEnablement]",
                "ppAdminEnvNaming": "[steps('environments').ppAdminEnvNaming]",
                "ppAdminRegion": "[steps('environments').ppAdminRegion]",
                "ppAdminDlp": "[steps('environments').ppAdminDlp]",
                "ppAdminManagedEnv": "[steps('environments').ppAdminManagedEnv]",
                "ppAdminBilling": "[steps('environments').ppAdminBilling]",
                "ppDefaultRenameText": "[steps('landingZones').ppDefaultRenameText]",
                "ppDefaultDlp": "[steps('landingZones').ppDefaultDlp]",
                "ppDefaultManagedEnv": "[steps('landingZones').ppDefaultManagedEnv]",
                "ppDefaultManagedSharing": "[steps('landingZones').ppDefaultManagedSharing]",
                "ppEnableAzureMonitor": "[steps('mgmt').ppEnableAzureMonitor]",
                "ppEnableAppInsights": "[steps('mgmt').ppEnableAppInsights]",
                "ppEnableAzureSecurity": "[steps('mgmt').ppEnableAzureSecurity]",
                "ppEnableD365Connector": "[steps('mgmt').ppEnableD365Connector]",
                "ppEnableAadLogs": "[steps('mgmt').ppEnableAadLogs]",
                "ppEnableTenantAnalytics": "[steps('mgmt').ppEnableTenantAnalytics]",
                "ppEnableDataLake": "[steps('mgmt').ppEnableDataLake]",
                "ppRetentionInDays": "[string(steps('mgmt').ppRetentionInDays)]",
                "ppCitizen": "[steps('landingZones').ppCitizen]",
                "ppCitizenConfiguration": "[replace(replace(replace(replace(replace(string(steps('landingZones').ppCitizenConfiguration), '{', ''), '}', ''), '\"', ''), '[', ''), ']', '')]",
                "ppCitizenCount": "[steps('landingZones').ppCitizenCount]",
                "ppCitizenNaming": "[steps('landingZones').ppCitizenNaming]",
                "ppCitizenDescription": "[steps('landingZones').ppCitizenDescription]",
                "ppCitizenLanguage": "[steps('landingZones').ppCitizenLanguage]",
                "ppCitizenCurrency": "[steps('landingZones').ppCitizenCurrency]",
                "ppCitizenRegion": "[steps('landingZones').ppCitizenRegion]",
                "ppCitizenDlp": "[steps('landingZones').ppCitizenDlp]",
                "ppCitizenManagedEnv": "[steps('landingZones').ppCitizenManagedEnv]",
                "ppCitizenAlm": "[steps('landingZones').ppCitizenAlm]",
                "ppCitizenBilling": "[steps('landingZones').ppCitizenBilling]",
                "ppPro": "[steps('landingZones').ppPro]",
                "ppProConfiguration": "[replace(replace(replace(replace(replace(string(steps('landingZones').ppProConfiguration), '{', ''), '}', ''), '\"', ''), '[', ''), ']', '')]",
                "ppProCount": "[steps('landingZones').ppProCount]",
                "ppProNaming": "[steps('landingZones').ppProNaming]",
                "ppProDescription": "[steps('landingZones').ppProDescription]",
                "ppProLanguage": "[steps('landingZones').ppProLanguage]",
                "ppProCurrency": "[steps('landingZones').ppProCurrency]",
                "ppProDlp": "[steps('landingZones').ppProDlp]",
                "ppProManagedEnv": "[steps('landingZones').ppProManagedEnv]",
                "ppProAlm": "[steps('landingZones').ppProAlm]",
                "ppProRegion": "[steps('landingZones').ppProRegion]",
                "ppProBilling": "[steps('landingZones').ppProBilling]",
                "ppSelectIndustry": "[steps('landingZones').ppSelectIndustry]",
                "ppIndustryNaming": "[steps('landingZones').ppIndustryNaming]",
                "ppIndustryRegion": "[steps('landingZones').ppIndustryRegion]",
                "ppIndustryManagedEnv": "[steps('landingZones').ppIndustryManagedEnv]",
                "ppIndustryBilling": "[steps('landingZones').ppIndustryBilling]",
                "ppIndustryAlm": "[steps('landingZones').ppIndustryAlm]"
            },
            "kind": "Subscription",
            "location": "[steps('powerp').locationName]",
            "subscriptionId": "[steps('powerp').subscriptionId]"
        }
    }
}
