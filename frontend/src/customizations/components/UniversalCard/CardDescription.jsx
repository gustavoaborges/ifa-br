
import React from 'react';
import { Card as UiCard } from 'semantic-ui-react';

const CardDescription = (props) => {
  const { item, itemModel = {}, description } = props;
  const { Description } = item;
  const { hasDescription } = itemModel;
  const desc = description || Description;
  const show = hasDescription && desc;

  return <p>"Coé"</p>;
};

export default CardDescription;