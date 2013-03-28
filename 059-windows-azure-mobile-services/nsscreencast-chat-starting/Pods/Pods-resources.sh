#!/bin/sh

install_resource()
{
  case $1 in
    *.storyboard)
      echo "ibtool --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.xib)
        echo "ibtool --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.framework)
      echo "rsync -rp ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -rp "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename $1 .xcdatamodeld`.momd"
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename $1 .xcdatamodeld`.momd"
      ;;
    *)
      echo "cp -R ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
      cp -R "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
      ;;
  esac
}
install_resource 'MessagesTableViewController/MessagesTableViewController/Resources/Images/input-bar.png'
install_resource 'MessagesTableViewController/MessagesTableViewController/Resources/Images/input-bar@2x.png'
install_resource 'MessagesTableViewController/MessagesTableViewController/Resources/Images/input-field.png'
install_resource 'MessagesTableViewController/MessagesTableViewController/Resources/Images/input-field@2x.png'
install_resource 'MessagesTableViewController/MessagesTableViewController/Resources/Images/messageBubbleBlue.png'
install_resource 'MessagesTableViewController/MessagesTableViewController/Resources/Images/messageBubbleBlue@2x.png'
install_resource 'MessagesTableViewController/MessagesTableViewController/Resources/Images/messageBubbleGray.png'
install_resource 'MessagesTableViewController/MessagesTableViewController/Resources/Images/messageBubbleGray@2x.png'
install_resource 'MessagesTableViewController/MessagesTableViewController/Resources/Images/messageBubbleHighlighted.png'
install_resource 'MessagesTableViewController/MessagesTableViewController/Resources/Images/messageBubbleHighlighted@2x.png'
install_resource 'MessagesTableViewController/MessagesTableViewController/Resources/Images/messageBubbleTyping.png'
install_resource 'MessagesTableViewController/MessagesTableViewController/Resources/Images/messageBubbleTyping@2x.png'
install_resource 'MessagesTableViewController/MessagesTableViewController/Resources/Images/send-highlighted.png'
install_resource 'MessagesTableViewController/MessagesTableViewController/Resources/Images/send-highlighted@2x.png'
install_resource 'MessagesTableViewController/MessagesTableViewController/Resources/Images/send.png'
install_resource 'MessagesTableViewController/MessagesTableViewController/Resources/Images/send@2x.png'
install_resource 'MessagesTableViewController/MessagesTableViewController/Resources/Sounds/messageReceived.aiff'
install_resource 'MessagesTableViewController/MessagesTableViewController/Resources/Sounds/messageSent.aiff'
